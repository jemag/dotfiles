#!/bin/sh
# Clear persisted agent_session bindings from herdr's session.json.
#
# Why this is needed:
#   herdr's managed agent integrations bind an "agent session" to a pane for
#   restore purposes. Once bound, herdr drops *every* pane.report_agent for that
#   pane -- from any source, any agent label, including the source that bound it.
#   Verified against herdr 0.8.0: pane.clear_agent_authority (with and without
#   --source), pane.release_agent from the owning source, and report_agent_session
#   with null ids all answer ok and leave the binding in place. So a pane that has
#   hosted e.g. opencode can never afterwards surface a nested claude session
#   (claude-code/.claude/hooks/herdr-claude-shim.sh reports into a void), and the
#   binding is persisted, so restarting herdr restores the problem.
#
#   The only way out is to edit session.json with the server stopped, which is
#   what this does. `[session] resume_agents_on_restore = false` means nothing
#   consumes these bindings anyway.
#
# Run this from a plain terminal, NOT from inside herdr: stopping the server kills
# every pane. Agents running in them survive as resumable sessions
# (claude --resume, opencode --continue), but unsaved work in editors does not.

set -eu

DEFAULT_SESSION_FILE="$HOME/.config/herdr/session.json"
SESSION_FILE="${HERDR_SESSION_FILE:-$DEFAULT_SESSION_FILE}"

dry_run=no
force=no
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=yes ;;
    --force) force=yes ;;
    *)
      echo "usage: $0 [--dry-run] [--force]" >&2
      exit 2
      ;;
  esac
done

if [ "${HERDR_ENV:-}" = "1" ] && [ "$force" = no ] && [ "$dry_run" = no ]; then
  echo "Refusing to run inside herdr: stopping the server would kill this pane." >&2
  echo "Run it from a plain terminal, or pass --force if you know what you are doing." >&2
  exit 1
fi

if [ ! -f "$SESSION_FILE" ]; then
  echo "No session file at $SESSION_FILE -- nothing to clear." >&2
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required." >&2
  exit 1
fi

# The server rewrites session.json every few seconds, so it has to be down before
# we touch the file or the save races the edit. Only ever stop the server that
# owns the file being edited: a HERDR_SESSION_FILE override points somewhere the
# running server does not write, so stopping it would kill a live session for no
# reason -- which is exactly how this guard came to be written.
if [ "$SESSION_FILE" != "$DEFAULT_SESSION_FILE" ] || [ "$dry_run" = yes ]; then
  if [ "$dry_run" = no ]; then
    echo "Target is not the live session file; leaving the running server alone."
  fi
elif herdr status server 2>/dev/null | grep -q '^status: running'; then
  echo "Stopping herdr server..."
  herdr server stop >/dev/null 2>&1 || true
  i=0
  while herdr status server 2>/dev/null | grep -q '^status: running'; do
    i=$((i + 1))
    if [ "$i" -gt 50 ]; then
      echo "Server still running after 10s; aborting without touching $SESSION_FILE." >&2
      exit 1
    fi
    sleep 0.2
  done
fi

backup="$SESSION_FILE.bak"
if [ "$dry_run" = no ]; then
  cp "$SESSION_FILE" "$backup"
fi

HERDR_SESSION_FILE="$SESSION_FILE" HERDR_CLEAR_DRY_RUN="$dry_run" python3 -c '
import json, os, sys

path = os.environ["HERDR_SESSION_FILE"]
dry_run = os.environ.get("HERDR_CLEAR_DRY_RUN") == "yes"
with open(path, encoding="utf-8") as fh:
    data = json.load(fh)

removed = []


def walk(node, where="pane"):
    global removed
    if isinstance(node, dict):
        binding = node.pop("agent_session", None)
        if binding is not None:
            removed.append(binding.get("source") or "?")
        for value in node.values():
            walk(value)
    elif isinstance(node, list):
        for value in node:
            walk(value)


walk(data)

if not removed:
    print("No agent_session bindings found.")
    sys.exit(0)

summary = "%d binding(s): %s" % (len(removed), ", ".join(sorted(set(removed))))
if dry_run:
    print("Would clear " + summary)
    sys.exit(0)

with open(path, "w", encoding="utf-8") as fh:
    json.dump(data, fh, indent=1)

print("Cleared " + summary)
'

if [ "$dry_run" = no ]; then
  echo "Backup kept at $backup"
  echo "Start herdr again with: herdr"
fi
