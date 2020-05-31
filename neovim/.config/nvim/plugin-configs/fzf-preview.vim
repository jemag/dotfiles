" Commands used for project grep
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --ignore-case --hidden --glob "!.git/*" --color "always"'
let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages --glob "!.git/*"'
let g:fzf_preview_split_key_map = 'ctrl-s'
let g:fzf_preview_fzf_color_option= 'bg:235'
let g:fzf_preview_floating_window_winblend = 0
" autocmd VimEnter * let g:fzf_preview_grep_command_options = fzf_preview#command#get_common_command_options() | let g:fzf_preview_grep_command_options = g:fzf_preview_grep_command_options . ' --nth=3'
