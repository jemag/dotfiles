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
# focused and the script exits.
#
# Usage: tmuxinator-launch.nu <project-name>
#
# Depends only on: herdr on PATH. YAML is parsed natively by `open`.

# Wait until the pane's shell process has spawned. Without this, commands
# sent right after pane creation get dropped (no shell is listening yet).
def wait_shell [pane_id: string] {
  mut deadline = ((date now) + 15sec)
  loop {
    let pid = (^herdr pane process-info --pane $pane_id | from json | get result.process_info.shell_pid?)
    if $pid != null {
      return
    }
    if ((date now) > $deadline) {
      print -e $"tmuxinator-launch.nu: timed out waiting for shell in ($pane_id)"
      exit 1
    }
    sleep 300ms
  }
}

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
    ^herdr pane rename $pane_id $pname | ignore
  }
  if ($cmd != null) {
    ^herdr pane run $pane_id $cmd | ignore
  }
}

# Build panes of a window from the tab's root pane. Pane order must match
# tmux reading order (left-to-right, top-to-bottom):
#   2 -> one right split
#   3 -> right split, then down split on the left (L shape)
#   4 -> 2x2 grid: right, down(left), down(right)
#   >4 -> cascade of right splits on the root pane
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
    let out = (^herdr pane split $parent --direction $dir --ratio 0.5 --no-focus | from json)
    let id = ($out.result.pane.pane_id)
    let info = (pane_info ($panes | get $idx))
    pane_setup $id $info.name $info.cmd
    $id
  }

  if $layout == "even-horizontal" {
    # Equal columns: keep splitting the original root pane. New pane gets a
    # ratio of 1/k of the remaining width so all columns come out equal.
    for k in (2..$n) {
      let ratio = (1.0 / $k | into string --decimals 6)
      let out = (^herdr pane split $root_pane --direction right --ratio $ratio --no-focus | from json)
      let id = ($out.result.pane.pane_id)
      $pane_ids = ($pane_ids | append $id)
      let info = (pane_info ($panes | get ($k - 1)))
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
  } else {
    for idx in (2..$n) {
      $pane_ids = ($pane_ids | append (new_pane $root_pane right ($idx - 1)))
    }
  }
}

def main [project: string] {
  let dir = ($env.TMUXINATOR_DIR? | default ($env.HOME | path join "dotfiles/tmuxinator/.config/tmuxinator"))
  let yaml_path = ($dir | path join $"($project).yml")

  if not ($yaml_path | path exists) {
    print -e $"tmuxinator-launch.nu: no project '($project)' (($yaml_path))"
    exit 1
  }

  let proj = (open $yaml_path)

  # ---------------------------------------------------------------------------
  # Idempotent: reuse an existing workspace with this label.
  # ---------------------------------------------------------------------------
  let existing = (^herdr workspace list | from json | get result.workspaces | where label == $project | get workspace_id? | get 0?)
  if ($existing != null) {
    ^herdr workspace focus $existing | ignore
    exit 0
  }

  let root = ($proj.root? | default "~")
  let windows = ($proj.windows? | default [])

  if ($windows | is-empty) {
    print -e $"tmuxinator-launch.nu: project '($project)' has no windows"
    exit 1
  }

  # ---------------------------------------------------------------------------
  # Create the workspace (with its first tab + root pane).
  # ---------------------------------------------------------------------------
  let created = (^herdr workspace create --cwd $root --label $project --no-focus | from json)
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
      ^herdr tab rename $first_tab_id $name | ignore
      build_window_panes $first_root_pane $layout $panes
    } else {
      let out = (^herdr tab create --workspace $workspace_id --cwd $root --label $name --no-focus | from json)
      let tab_id = ($out.result.tab.tab_id)
      let root_pane = ($out.result.root_pane.pane_id)
      build_window_panes $root_pane $layout $panes
    }
  }

  # Focus the workspace so the created layout is on screen.
  ^herdr workspace focus $workspace_id | ignore
  print -e $"launched tmuxinator project '($project)' into workspace '($workspace_id)'"
}