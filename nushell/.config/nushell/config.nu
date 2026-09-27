# Only overrides of Nushell's built-in defaults live here.
# `config nu --doc` documents every option and its default.

$env.config.edit_mode = 'vi'
$env.config.cursor_shape = { emacs: line, vi_insert: line, vi_normal: block }
$env.config.table.mode = 'thin'
$env.config.filesize.unit = 'binary'
$env.config.history.file_format = 'sqlite'
$env.config.completions.algorithm = 'fuzzy'
$env.config.hooks.display_output = "if (term size).columns >= 100 { table -e } else { table }"

$env.config.keybindings ++= [
    {
        name: fuzzy_dir
        modifier: alt
        keycode: char_c
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --append (fd --type d |fzf --height 50% -1 --layout=reverse --multi --inline-info --preview 'eza --tree --color=always {} | head -n 200')"
        }
    }
    {
        name: fuzzy_file
        modifier: control
        keycode: char_t
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --insert (fzf --height 50% -1 --layout=reverse --multi --inline-info --preview 'bat --style=numbers --color=always --line-range :500 {}')"
        }
    }
    {
        name: fuzzy_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit (
                      history
                      | where exit_status == 0
                      | get command
                      | reverse
                      | uniq
                      | str join (char -i 0)
                      | fzf --read0 --height 40% --reverse --inline-info +s --bind 'tab:down' --bind 'shift-tab:up' -q (commandline)
                      | decode utf-8
                      | str trim
                  )"
        }
    }
    {
        name: open_command_editor
        modifier: control
        keycode: char_o
        mode: [emacs, vi_normal, vi_insert]
        event: { send: openeditor }
    }
    {
        name: move_one_word_right_or_take_history_hint
        modifier: control
        keycode: right
        mode: [emacs, vi_normal, vi_insert]
        event: { until: [{ send: historyhintwordcomplete } { edit: movewordright }] }
    }
    {
        name: move_to_line_start_ctrl_a
        modifier: control
        keycode: char_a
        mode: [emacs, vi_normal, vi_insert]
        event: { edit: movetolinestart }
    }
    {
        name: move_to_line_end_or_take_history_hint
        modifier: control
        keycode: char_f
        mode: [emacs, vi_normal, vi_insert]
        event: { until: [{ send: historyhintcomplete } { edit: movetolineend }] }
    }
    {
        name: move_up_ctrl_p
        modifier: control
        keycode: char_p
        mode: [emacs, vi_normal, vi_insert]
        event: { until: [{ send: menuup } { send: up }] }
    }
    {
        name: move_down_ctrl_n
        modifier: control
        keycode: char_n
        mode: [emacs, vi_normal, vi_insert]
        event: { until: [{ send: menudown } { send: down }] }
    }
    {
        name: delete_one_word_backward_ctrl_w
        modifier: control
        keycode: char_w
        mode: [emacs, vi_insert]
        event: { edit: backspaceword }
    }
]

use aliases.nu *
use kubernetes.nu *

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
source ~/.cache/nu/zoxide/zoxide.nu
source ~/.cache/carapace/carapace.nu
