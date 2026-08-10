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
#   One catch, verified against herdr 0.7.5: once any agent *session* is bound to
#   a pane, herdr silently drops every pane.report_agent for that pane. herdr's
#   managed claude hook bound one on every SessionStart, which is why this script
#   appeared to do nothing. That hook is therefore uninstalled outright
#   (`herdr integration uninstall claude`); it only ever reported session identity
#   for restore, and `[session] resume_agents_on_restore = false` already disabled
#   the only consumer of that. Do not reinstall it -- it will silently re-break
#   nested detection, and it rewrites the hook entries in settings.json.
#
#   Direct (non-nested) claude panes are left completely untouched: this script
#   exits early unless $NVIM is set, so they keep herdr's screen-manifest
#   detection, which never depended on the hook.
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

AGENT="claude"
# Must stay stable, unique, and outside the reserved "herdr:" namespace.
SOURCE="custom:claude-nvim"

# Monotonic sequence number so out-of-order reports are discarded by herdr.
seq=$(date +%s%N)

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
[ "$is_subagent" = "1" ] && exit 0
# SubagentStop is a completion event that can fire after the main turn already
# stopped -- it must never revive an idle pane.
[ "$hook_event" = "SubagentStop" ] && exit 0

report_state() {
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

case "$action" in
  session-start|idle)
    report_state idle
    ;;
  working)
    report_state working
    ;;
  blocked)
    report_state blocked
    ;;
  session-end)
    "$HERDR" pane release-agent "$HERDR_PANE_ID" \
      --source "$SOURCE" --agent "$AGENT" --seq "$seq" >/dev/null 2>&1 || true
    ;;
  *) ;;
esac

exit 0
