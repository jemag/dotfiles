#!/bin/sh
# Surface a nested Claude Code session (running inside a neovim terminal) in herdr.
#
# Why this exists:
#   herdr derives a pane's agent from the pane's *foreground process*. When claude
#   runs in a neovim terminal buffer the foreground process is nvim, so the pane
#   has no agent at all: screen manifest rules never run, and the pane sits at
#   agent_status "unknown" forever.
#
#   herdr's own claude integration cannot fix this. Per herdr's docs its role is
#   "session identity" only -- it reports the session id for restore and is
#   deliberately not a lifecycle authority -- so pane.report_agent calls carrying
#   source "herdr:claude" are dropped no matter what the detection manifest says.
#
#   The supported escape hatch is a custom integration source
#   (herdr.dev/docs/integrations -> "Integrate your own agent"): a report from a
#   "custom:*" source both establishes the agent on the pane and authors its
#   state, with no reliance on process detection.
#
# Why the reported agent is not called "claude", verified against herdr 0.8.0:
#   herdr silently discards every pane.report_agent whose --agent is "claude",
#   its manifest alias "claude-code", or any casing of either -- from any source,
#   including "custom:*". An otherwise identical report with a different label is
#   accepted. This is the enforcement side of "Claude Code state comes from
#   Herdr's screen manifest detection": claude's state is manifest-only, period.
#   It used to be reportable in 0.7.5, which is why this shim silently stopped
#   working at the 0.8.0 upgrade.
#
#   So nested sessions report as a distinct agent, AGENT below. That is not just
#   a workaround for the filter, it is what makes the state correct: with a label
#   herdr has no manifest for, these hooks are the sole authority and no screen
#   rule can contradict them. Under the "claude" label the pane was scored by
#   scraping *nvim's* rendering of the claude buffer, where the blocked rules
#   (whole_recent scrollback, loose "do you want to" + yes/prompt patterns) match
#   easily while the visible_idle rule needs `^\s*❯` in the real prompt box --
#   unmatchable behind nvim's line numbers, borders and wrapping. herdr will not
#   clear a blocked status from non-visible evidence, so a finished nested agent
#   latched red forever, and stayed red even with its buffer hidden entirely.
#
#   Two known gaps, both strictly better than a stuck blocker: an interrupt (esc)
#   fires no hook, so the pane reads working until the next turn completes; and a
#   session killed with the terminal buffer never reaches SessionEnd, so nvim
#   releases the agent from a TermClose/VimLeavePre autocmd (see settings.lua).
#
#   Also verified in 0.8.0: a pane carrying an agent_session bound by a built-in
#   integration (e.g. a leftover herdr:opencode binding from an earlier session in
#   that pane) drops *every* agent report, whatever the label or source. There is
#   no API to clear it -- pane.clear_agent_authority answers ok and leaves it, and
#   release-agent does not drop it -- and it is persisted in session.json. Nested
#   claude simply cannot be surfaced in such a pane; recreate the pane, or stop
#   the server and scrub the binding.
#
#   herdr's managed claude hook must stay uninstalled
#   (`herdr integration uninstall claude`). It bound an agent_session on every
#   SessionStart, i.e. the paragraph above, self-inflicted. It only ever reported
#   session identity for restore, and `[session] resume_agents_on_restore = false`
#   already disabled the only consumer of that. Reinstalling it silently re-breaks
#   nested detection and rewrites the hook entries in settings.json.
#
#   Direct (non-nested) claude panes are left completely untouched: this script
#   exits early unless $NVIM is set, so they keep herdr's screen-manifest
#   detection, which never depended on the hook.
#
# Set HERDR_CLAUDE_SHIM_LOG=<path> to trace decisions. herdr reports fail
# silently by design -- that is how the 0.8.0 breakage went unnoticed -- so this
# is the only way to see what the shim actually did.
#
# This file is NOT managed by herdr.

set -eu

action="${1:-}"

# Always drain stdin so claude never blocks on a full pipe.
hook_input_file="$(mktemp "${TMPDIR:-/tmp}/herdr-claude-shim.XXXXXX")" || exit 0
trap 'rm -f "$hook_input_file"' EXIT HUP INT TERM
cat >"$hook_input_file" 2>/dev/null || true

# --- guards ------------------------------------------------------------------
# Any failure past this point must be silent and exit 0: a hook that errors or
# writes to stdout interferes with claude itself.

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_SOCKET_PATH:-}" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
# Only nested sessions. nvim exports $NVIM to processes it spawns in a terminal
# buffer. A direct claude pane must keep herdr's screen-manifest authority, which
# covers transitions claude's hooks miss (interrupts, some permission outcomes).
[ -n "${NVIM:-}" ] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

HERDR="${HERDR_BIN_PATH:-}"
if [ -z "$HERDR" ]; then
  command -v herdr >/dev/null 2>&1 || exit 0
  HERDR=herdr
fi

# Must not be "claude", "claude-code", or any casing of those: herdr drops those
# reports. Keep in sync with the release call in neovim's settings.lua.
AGENT="claude-nvim"
# Must stay stable, unique, and outside the reserved "herdr:" namespace.
SOURCE="custom:claude-nvim"

# Monotonic sequence number so out-of-order reports are discarded by herdr.
seq=$(date +%s%N)

trace() {
  [ -n "${HERDR_CLAUDE_SHIM_LOG:-}" ] || return 0
  printf '%s pane=%s action=%s %s\n' \
    "$(date -Is 2>/dev/null || echo -)" "$HERDR_PANE_ID" "$action" "$*" \
    >>"$HERDR_CLAUDE_SHIM_LOG" 2>/dev/null || true
}

# --- hook payload ------------------------------------------------------------
# Emits: <is_subagent>\n<hook_event_name>\n<message>
# Session identity is intentionally not reported: herdr only accepts session
# references from its own built-in integrations, and binding one would lock this
# pane out of state reports entirely.
parsed=$(HERDR_HOOK_INPUT_FILE="$hook_input_file" python3 -c '
import json, os

try:
    with open(os.environ["HERDR_HOOK_INPUT_FILE"], encoding="utf-8") as fh:
        content = fh.read()
    data = json.loads(content) if content.strip() else {}
    if not isinstance(data, dict):
        data = {}
except Exception:
    data = {}


def field(key):
    value = data.get(key)
    return value.replace("\n", " ") if isinstance(value, str) and value else ""


print("1" if data.get("agent_id") else "0")
print(field("hook_event_name"))
print(field("message"))
' 2>/dev/null) || exit 0

is_subagent=$(printf '%s\n' "$parsed" | sed -n '1p')
hook_event=$(printf '%s\n' "$parsed" | sed -n '2p')
message=$(printf '%s\n' "$parsed" | sed -n '3p')

# Subagents share the pane but not the turn lifecycle; their events would
# desynchronise the main session's state.
if [ "$is_subagent" = "1" ]; then
  trace "skipped: subagent event $hook_event"
  exit 0
fi
# SubagentStop is a completion event that can fire after the main turn already
# stopped -- it must never revive an idle pane.
if [ "$hook_event" = "SubagentStop" ]; then
  trace "skipped: SubagentStop"
  exit 0
fi

report_state() {
  trace "report state=$1 message=${message:--}"
  if [ -n "$message" ]; then
    "$HERDR" pane report-agent "$HERDR_PANE_ID" \
      --source "$SOURCE" --agent "$AGENT" --state "$1" \
      --message "$message" --seq "$seq" >/dev/null 2>&1 || true
  else
    "$HERDR" pane report-agent "$HERDR_PANE_ID" \
      --source "$SOURCE" --agent "$AGENT" --state "$1" \
      --seq "$seq" >/dev/null 2>&1 || true
  fi
}

# A pane carrying an agent_session bound by another source drops every report we
# make, and there is no way to detect that from the report itself -- herdr answers
# ok and does nothing. Say so once per session instead of leaving a pane silently
# colourless: nothing here can fix it, only
# herdr/.config/herdr/scripts/clear-agent-sessions.sh can.
warn_if_pane_is_deaf() {
  foreign=$("$HERDR" pane get "$HERDR_PANE_ID" 2>/dev/null | python3 -c '
import json, sys

try:
    pane = json.load(sys.stdin)["result"]["pane"]
    session = pane.get("agent_session") or {}
    source = session.get("source") or ""
except Exception:
    source = ""
print(source)
' 2>/dev/null) || return 0
  [ -n "$foreign" ] || return 0
  [ "$foreign" != "$SOURCE" ] || return 0
  trace "pane is deaf: agent_session held by $foreign"
  "$HERDR" notification show "herdr: pane $HERDR_PANE_ID cannot report agent state" \
    --body "An agent_session from $foreign is bound to this pane and drops every state report. Run scripts/clear-agent-sessions.sh to clear it." \
    --sound none >/dev/null 2>&1 || true
}

case "$action" in
  session-start|idle)
    [ "$action" = "session-start" ] && warn_if_pane_is_deaf
    report_state idle
    ;;
  working)
    report_state working
    ;;
  blocked)
    # Notification fires for two unrelated things: a real blocker (claude wants
    # permission to use a tool) and a nag once the prompt has sat idle for 60s.
    # The nag arrives *after* Stop already reported idle, so treating it as a
    # blocker repaints a finished agent red -- and it can also arrive while a
    # permission prompt is genuinely pending, so it cannot be mapped to idle
    # either. Report nothing and leave the last real state standing.
    case "$message" in
      *"waiting for your input"* | *"is waiting for"*)
        trace "skipped: idle nag ($message)"
        ;;
      *)
        report_state blocked
        ;;
    esac
    ;;
  session-end)
    trace "release"
    "$HERDR" pane release-agent "$HERDR_PANE_ID" \
      --source "$SOURCE" --agent "$AGENT" --seq "$seq" >/dev/null 2>&1 || true
    ;;
  *) ;;
esac

exit 0
