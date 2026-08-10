#!/usr/bin/env nu
#
# tmuxinator-launch.nu — build a herdr workspace from a tmuxinator project.
#
# Nushell port of tmuxinator-launch.sh. Same mapping and layout
# approximations (herdr only has right/down binary splits):
#   project root  -> workspace --cwd   (label = yml basename, keeps names unique)
#   window        -> tab
#   pane          -> pane split + optional rename + run command(s)
#   tiled         -> grid built from right/down splits (2x2 for 4, L for 3)
#   even-horizontal -> equal columns by re-splitting the root pane
#
# Idempotent: if a workspace with the project's label already exists, it is
# focused instead of rebuilt.
#
# Works both inside and outside herdr:
#   - inside a herdr pane/popup: builds (or focuses) the workspace and returns.
#   - from a plain shell: starts a headless server first if none is running,
#     builds the workspace, then execs `herdr` so the terminal attaches to it.
#
# Self-contained like the old tmuxinator-fzf-start.sh: with no argument, lists
# the tmuxinator projects and fuzzy-picks one (or more) with fzf. With a
# project name argument, builds it directly without prompting, so the script
# can be called non-interactively from other scripts.
#
# Usage: tmuxinator-launch.nu [project-name]
#
# Depends only on: herdr, fzf, nu on PATH. YAML is parsed natively by `open`.

const SCRIPT = "tmuxinator-launch.nu"

def die [msg: string] {
  print -e $"($SCRIPT): ($msg)"
  exit 1
}

def tmuxinator_dir [] {
  $env.TMUXINATOR_DIR? | default ($env.HOME | path join "dotfiles/tmuxinator/.config/tmuxinator")
}

# True when we are already running inside a herdr pane or popup.
def inside_herdr [] {
  ($env.HERDR_ENV? | default "") == "1"
}

# ---------------------------------------------------------------------------
# herdr API helpers
# ---------------------------------------------------------------------------

# Run a herdr subcommand and return its parsed JSON response. Any failure
# (server down, bad ids, malformed output) is reported with the actual stderr
# instead of a bare nushell decoding error.
def herdr_json [args: list<string>] {
  let out = (^herdr ...$args | complete)
  if $out.exit_code != 0 {
    let err = ($out.stderr | str trim)
    let err = (if ($err | is-empty) { ($out.stdout | str trim) } else { $err })
    die $"`herdr ($args | str join ' ')` failed: ($err)"
  }
  try {
    $out.stdout | from json
  } catch {
    die $"`herdr ($args | str join ' ')` returned unexpected output: ($out.stdout | str trim)"
  }
}

def server_running [] {
  let out = (^herdr status --json | complete)
  if $out.exit_code != 0 {
    return false
  }
  try {
    ($out.stdout | from json | get server.running?) == true
  } catch {
    false
  }
}

# Make sure a herdr server exists before we start issuing API calls. The CLI
# never autostarts one, so without this every command fails with a raw OS error.
def ensure_server [] {
  if (server_running) {
    return
  }
  if (inside_herdr) {
    # Should not happen, but never try to spawn a second server from a pane.
    die "herdr server is not reachable from inside this pane"
  }

  let log = ($env.HOME | path join ".config/herdr/herdr-server.log")
  print -e $"($SCRIPT): no herdr server running, starting one..."
  ^setsid --fork herdr server out>> $log err>> $log

  let deadline = ((date now) + 15sec)
  loop {
    if (server_running) {
      return
    }
    if ((date now) > $deadline) {
      die $"timed out waiting for the herdr server to start, see ($log)"
    }
    sleep 200ms
  }
}

# Wait until the pane's shell process has spawned. Without this, commands
# sent right after pane creation get dropped (no shell is listening yet).
def wait_shell [pane_id: string] {
  let deadline = ((date now) + 15sec)
  loop {
    let pid = (herdr_json [pane process-info --pane $pane_id] | get result.process_info.shell_pid?)
    if $pid != null {
      return
    }
    if ((date now) > $deadline) {
      die $"timed out waiting for shell in ($pane_id)"
    }
    sleep 300ms
  }
}

# ---------------------------------------------------------------------------
# tmuxinator YAML -> herdr
# ---------------------------------------------------------------------------

# Decode one pane entry. Returns {name: <string|null>, cmd: <string|null>}.
#   bare string          -> {name: null, cmd: "<string>"}
#   named with commands  -> {name: <name>, cmd: "cmd1 && cmd2"}
#   named with no cmds   -> {name: <name>, cmd: null}
def pane_info [pane] {
  if ($pane | describe) == "string" {
    { name: null, cmd: $pane }
  } else {
    let key = ($pane | columns | get 0)
    let val = ($pane | get $key)
    if ($val | describe) == "nothing" {
      { name: $key, cmd: null }
    } else {
      { name: $key, cmd: ($val | str join " && ") }
    }
  }
}

# run/rename one pane.
def pane_setup [pane_id: string, pname?: string, cmd?: string] {
  wait_shell $pane_id
  if ($pname != null) {
    herdr_json [pane rename $pane_id $pname] | ignore
  }
  if ($cmd != null) {
    herdr_json [pane run $pane_id $cmd] | ignore
  }
}

# Build panes of a window from the tab's root pane. Pane order must match
# tmux reading order (left-to-right, top-to-bottom):
#   2 -> one right split
#   3 -> right split, then down split on the left (L shape)
#   4 -> 2x2 grid: right, down(left), down(right)
#   >4 -> equal columns, same as even-horizontal
def build_window_panes [root_pane: string, layout: string, panes: list] {
  if ($panes | is-empty) {
    return
  }
  let n = ($panes | length)
  let root_info = (pane_info ($panes | get 0))
  pane_setup $root_pane $root_info.name $root_info.cmd
  if $n == 1 {
    return
  }

  mut pane_ids = [$root_pane]

  # New pane for index $idx off parent $parent with direction $dir.
  # Returns the new pane id; caller must append it so the 2x2 grid can
  # address the first-right pane for its down split.
  def new_pane [parent: string, dir: string, idx: int] {
    let out = (herdr_json [pane split $parent --direction $dir --ratio "0.5" --no-focus])
    let id = ($out.result.pane.pane_id)
    let info = (pane_info ($panes | get $idx))
    pane_setup $id $info.name $info.cmd
    $id
  }

  if $layout == "even-horizontal" or ($n > 4) {
    # Equal columns, all carved out of the original root pane.
    #
    # herdr's --ratio is the share kept by the pane being split, and the new
    # pane always lands immediately to its right. So splitting the root n-1
    # times lays the new panes out right-to-left:
    #     root | last-created | ... | first-created
    # Step k (k = 2..n) must therefore fill column index (n - k + 1), and must
    # leave the root holding (n - k + 1) of the (n - k + 2) columns it still
    # owns, which makes every column exactly 1/n of the width.
    for k in (2..$n) {
      let remaining = ($n - $k + 2)
      let ratio = (($remaining - 1) / $remaining | into string --decimals 6)
      let out = (herdr_json [pane split $root_pane --direction right --ratio $ratio --no-focus])
      let id = ($out.result.pane.pane_id)
      $pane_ids = ($pane_ids | append $id)
      let info = (pane_info ($panes | get ($n - $k + 1)))
      pane_setup $id $info.name $info.cmd
    }
  } else if $n == 2 {
    $pane_ids = ($pane_ids | append (new_pane $root_pane right 1))
  } else if $n == 3 {
    $pane_ids = ($pane_ids | append (new_pane $root_pane right 1))
    $pane_ids = ($pane_ids | append (new_pane $root_pane down 2))
  } else if $n == 4 {
    # split root right -> right column (top-right)
    $pane_ids = ($pane_ids | append (new_pane $root_pane right 1))
    # split root down -> left column bottom
    $pane_ids = ($pane_ids | append (new_pane $root_pane down 2))
    # split the right column down -> bottom-right
    $pane_ids = ($pane_ids | append (new_pane ($pane_ids | get 1) down 3))
  }
}

# Build (or focus) the workspace for a project. Returns its workspace id.
def build_project [project: string] {
  let yaml_path = (tmuxinator_dir | path join $"($project).yml")

  if not ($yaml_path | path exists) {
    die $"no project '($project)' at ($yaml_path)"
  }

  let proj = (open $yaml_path)

  # ---------------------------------------------------------------------------
  # Idempotent: reuse an existing workspace with this label.
  # ---------------------------------------------------------------------------
  let existing = (
    herdr_json [workspace list]
    | get result.workspaces
    | where label == $project
    | get workspace_id?
    | get 0?
  )
  if ($existing != null) {
    herdr_json [workspace focus $existing] | ignore
    return $existing
  }

  let root = ($proj.root? | default "~" | path expand --no-symlink)
  let windows = ($proj.windows? | default [])

  if ($windows | is-empty) {
    die $"project '($project)' has no windows"
  }

  # ---------------------------------------------------------------------------
  # Create the workspace (with its first tab + root pane).
  # ---------------------------------------------------------------------------
  let created = (herdr_json [workspace create --cwd $root --label $project --no-focus])
  let workspace_id = ($created.result.workspace.workspace_id)
  let first_tab_id = ($created.result.tab.tab_id)
  let first_root_pane = ($created.result.root_pane.pane_id)

  # ---------------------------------------------------------------------------
  # Create tabs (windows) and their panes.
  # ---------------------------------------------------------------------------
  for w in ($windows | enumerate) {
    let name = ($w.item | columns | get 0)
    let spec = ($w.item | get $name)
    let layout = ($spec.layout? | default "tiled")
    let panes = ($spec.panes? | default [])

    if $w.index == 0 {
      herdr_json [tab rename $first_tab_id $name] | ignore
      build_window_panes $first_root_pane $layout $panes
    } else {
      let out = (herdr_json [tab create --workspace $workspace_id --cwd $root --label $name --no-focus])
      let tab_id = ($out.result.tab.tab_id)
      let root_pane = ($out.result.root_pane.pane_id)
      build_window_panes $root_pane $layout $panes
    }
  }

  # Focus the workspace so the created layout is on screen.
  herdr_json [workspace focus $workspace_id] | ignore
  print -e $"($SCRIPT): launched tmuxinator project '($project)' into workspace '($workspace_id)'"
  $workspace_id
}

def main [project?: string] {
  if (which herdr | is-empty) {
    die "herdr is not on PATH"
  }

  let dir = (tmuxinator_dir)

  let projects = (
    if ($project != null) {
      [$project]
    } else {
      if not ($dir | path exists) {
        die $"tmuxinator directory not found: ($dir)"
      }
      if (which fzf | is-empty) {
        die "fzf is not on PATH (required to pick a project interactively)"
      }
      let picked = (
        try {
          ls $"($dir)/*.yml"
          | get name
          | path basename
          | str replace -r '\.yml$' ''
          | str join (char nl)
          | ^fzf --prompt "Project: " -m -1 --reverse --height 50%
        } catch {
          "" # fzf returns non-zero on cancel (Esc)
        }
      )
      $picked | lines | each {|p| $p | str trim } | where {|p| $p != "" }
    }
  )

  if ($projects | is-empty) {
    exit 0
  }

  ensure_server

  for p in $projects {
    build_project $p | ignore
  }

  # From a plain shell there is no client showing what we just built, so attach.
  if not (inside_herdr) {
    exec herdr
  }
}
