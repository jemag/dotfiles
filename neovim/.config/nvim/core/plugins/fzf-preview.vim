" Commands used for project grep
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --ignore-case --hidden --glob "!.git/*" --color "always"'
let g:fzf_preview_split_key_map = 'ctrl-s'
" autocmd VimEnter * let g:fzf_preview_grep_command_options = fzf_preview#command#get_common_command_options() | let g:fzf_preview_grep_command_options = g:fzf_preview_grep_command_options . ' --nth=3'
