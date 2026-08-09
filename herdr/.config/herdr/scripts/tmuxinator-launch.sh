#!/usr/bin/env bash
#
# tmuxinator-launch.sh — build a herdr workspace from a tmuxinator project.
#
# Maps each tmuxinator project (YAML) to a herdr workspace:
#   project root  -> workspace --cwd   (label = yml basename, keeps names unique)
#   window        -> tab
#   pane          -> pane split + optional rename + run command(s)
#
# Layout approximation (herdr only has right/down binary splits):
#   tiled            -> grid built from right/down splits (2x2 for 4, L for 3)
#   even-horizontal  -> equal columns by re-splitting the root pane
#
# Idempotent: if a workspace with the project's label already exists, it is
# focused and the script exits.
#
# Usage: tmuxinator-launch.sh <project-name>
#
# Depends on: yq (mikefarah >= 4), jq, herdr on PATH.

set -euo pipefail

PROJECT="${1:?usage: tmuxinator-launch.sh <project-name>}"

TMUXINATOR_DIR="${TMUXINATOR_DIR:-$HOME/dotfiles/tmuxinator/.config/tmuxinator}"
YAML="$TMUXINATOR_DIR/$PROJECT.yml"

if [[ ! -f "$YAML" ]]; then
  echo "tmuxinator-launch.sh: no project '$PROJECT' ($YAML)" >&2
  exit 1
fi

herdr() { command herdr "$@"; }
jq() { command jq "$@"; }
yq() { command yq -r "$@"; }

# ---------------------------------------------------------------------------
# Idempotent: reuse an existing workspace with this label.
# ---------------------------------------------------------------------------
EXISTING=$(herdr workspace list | jq -r --arg l "$PROJECT" \
  '.result.workspaces[] | select(.label == $l) | .workspace_id' | head -1)
if [[ -n "$EXISTING" ]]; then
  herdr workspace focus "$EXISTING" >/dev/null
  exit 0
fi

ROOT=$(yq '.root // "~"' "$YAML")
WINDOW_COUNT=$(yq '.windows | length // 0' "$YAML")
if [[ "$WINDOW_COUNT" -eq 0 ]]; then
  echo "tmuxinator-launch.sh: project '$PROJECT' has no windows" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Create the workspace (with its first tab + root pane).
# ---------------------------------------------------------------------------
CREATED=$(herdr workspace create --cwd "$ROOT" --label "$PROJECT" --no-focus)
WORKSPACE_ID=$(jq -r '.result.workspace.workspace_id' <<<"$CREATED")
FIRST_TAB_ID=$(jq -r '.result.tab.tab_id' <<<"$CREATED")
FIRST_ROOT_PANE=$(jq -r '.result.root_pane.pane_id' <<<"$CREATED")

# Prints two lines for panes[$1] of the global $window_idx window:
#   line 1: pane name ('' for bare-string panes)
#   line 2: command  ('' for named panes that have no commands)
# Bare-string panes (`- clear`) -> "\nclear". Named panes with a command list
# (`- kubie_dev: [cmd1, cmd2]`) -> "kubie_dev\ncmd1 && cmd2". Named panes
# without commands (`- kubectl.nvim:`) -> "kubectl.nvim\n".
pane_command() {
  local idx="$1"
  local ptype cmds pname is_null
  ptype=$(yq ".windows[$window_idx][\"$window_name\"].panes[$idx] | type" "$YAML")
  if [[ "$ptype" == "!!str" ]]; then
    local cmd
    cmd=$(yq ".windows[$window_idx][\"$window_name\"].panes[$idx]" "$YAML")
    printf '\n%s\n' "$cmd"
    return
  fi
  pname=$(yq ".windows[$window_idx][\"$window_name\"].panes[$idx] | keys[0]" "$YAML")
  is_null=$(yq ".windows[$window_idx][\"$window_name\"].panes[$idx][\"$pname\"] == null" "$YAML")
  if [[ "$is_null" == "true" ]]; then
    printf '%s\n\n' "$pname"
  else
    cmds=$(yq ".windows[$window_idx][\"$window_name\"].panes[$idx][\"$pname\"] | join(\" && \")" "$YAML")
    printf '%s\n%s\n' "$pname" "$cmds"
  fi
}

# Wait until the pane's shell process has spawned. Without this, commands sent
# right after pane creation get dropped (no shell is listening yet).
# $1 = pane id
wait_shell() {
  local pane_id="$1"
  local deadline=$((SECONDS + 15))
  while ((SECONDS < deadline)); do
    local pid
    pid=$(herdr pane process-info --pane "$pane_id" 2>/dev/null \
      | jq -r '.result.process_info.shell_pid // empty')
    if [[ -n "$pid" ]]; then
      return 0
    fi
    sleep 0.3
  done
  echo "tmuxinator-launch.sh: timed out waiting for shell in $pane_id" >&2
  return 1
}

# run/rename one pane: $1 = pane id, $2 = name ('' = skip), $3 = cmd ('' = skip)
pane_setup() {
  local pane_id="$1"
  local pname="$2"
  local cmd="$3"
  wait_shell "$pane_id"
  if [[ -n "$pname" ]]; then
    herdr pane rename "$pane_id" "$pname" >/dev/null
  fi
  if [[ -n "$cmd" ]]; then
    herdr pane run "$pane_id" "$cmd" >/dev/null
  fi
}

# Build panes of a window: $1 = root pane id, $2 = layout, $3 = pane count
build_window_panes() {
  local root_pane="$1"
  local layout="$2"
  local npanes="$3"

  if [[ "$npanes" -eq 0 ]]; then
    return
  fi

  local p idx dir ratio target new_pane

  # First pane runs in the tab's root pane.
  mapfile -t p < <(pane_command 0)
  pane_setup "$root_pane" "${p[0]:-}" "${p[1]:-}"

  # pane ids in tmux reading order: root is index 0.
  local -a pane_ids=("$root_pane")

  if [[ "$layout" == "even-horizontal" ]]; then
    # Equal columns: keep splitting the original root pane. New pane gets a
    # ratio of 1/k of the remaining width so all columns come out equal.
    for k in $(seq 2 "$npanes"); do
      ratio=$(awk -v k="$k" 'BEGIN{printf "%.6f", 1.0/k}')
      new_pane=$(herdr pane split "$root_pane" --direction right --ratio "$ratio" --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      idx=$((k - 1))
      mapfile -t p < <(pane_command "$idx")
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
    done
    return
  fi

  # tiled (tmuxinator default). Approximate with binary splits so the created
  # pane order matches tmux reading order (left-to-right, top-to-bottom):
  #   2 -> one right split
  #   3 -> right split, then down split on the left (L shape)
  #   4 -> 2x2 grid: right, down(left), down(right)
  #   >4 -> cascade of right splits on the root pane
  case "$npanes" in
    2)
      new_pane=$(herdr pane split "$root_pane" --direction right --ratio 0.5 --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      idx=1
      mapfile -t p < <(pane_command "$idx")
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      ;;
    3)
      new_pane=$(herdr pane split "$root_pane" --direction right --ratio 0.5 --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      idx=1
      mapfile -t p < <(pane_command "$idx")
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      new_pane=$(herdr pane split "$root_pane" --direction down --ratio 0.5 --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      idx=2
      mapfile -t p < <(pane_command "$idx")
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      ;;
    4)
      # split root right -> right column (top-right)
      new_pane=$(herdr pane split "$root_pane" --direction right --ratio 0.5 --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      mapfile -t p < <(pane_command 1)
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      # split root down -> left column bottom
      new_pane=$(herdr pane split "$root_pane" --direction down --ratio 0.5 --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      mapfile -t p < <(pane_command 2)
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      # split the right column down -> bottom-right
      new_pane=$(herdr pane split "${pane_ids[1]}" --direction down --ratio 0.5 --no-focus \
        | jq -r '.result.pane.pane_id')
      pane_ids+=("$new_pane")
      mapfile -t p < <(pane_command 3)
      pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      ;;
    *)
      for idx in $(seq 1 $((npanes - 1))); do
        new_pane=$(herdr pane split "$root_pane" --direction right --ratio 0.5 --no-focus \
          | jq -r '.result.pane.pane_id')
        mapfile -t p < <(pane_command "$idx")
        pane_setup "$new_pane" "${p[0]:-}" "${p[1]:-}"
      done
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Create tabs (windows) and their panes.
# ---------------------------------------------------------------------------
for ((window_idx = 0; window_idx < WINDOW_COUNT; window_idx++)); do
  window_name=$(yq ".windows[$window_idx] | keys[0]" "$YAML")
  layout=$(yq ".windows[$window_idx][\"$window_name\"].layout // \"tiled\"" "$YAML")
  npanes=$(yq ".windows[$window_idx][\"$window_name\"].panes | length // 0" "$YAML")

  if ((window_idx == 0)); then
    TAB_ID=$FIRST_TAB_ID
    ROOT_PANE=$FIRST_ROOT_PANE
    herdr tab rename "$TAB_ID" "$window_name" >/dev/null
  else
    TAB_TMP=$(herdr tab create --workspace "$WORKSPACE_ID" --cwd "$ROOT" --label "$window_name" --no-focus)
    TAB_ID=$(jq -r '.result.tab.tab_id' <<<"$TAB_TMP")
    ROOT_PANE=$(jq -r '.result.root_pane.pane_id' <<<"$TAB_TMP")
  fi

  build_window_panes "$ROOT_PANE" "$layout" "$npanes"
done

# Focus the workspace so the created layout is on screen.
herdr workspace focus "$WORKSPACE_ID" >/dev/null
echo "launched tmuxinator project '$PROJECT' into workspace '$WORKSPACE_ID'" >&2