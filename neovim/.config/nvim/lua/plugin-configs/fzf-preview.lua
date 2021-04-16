" Commands used for project grep
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --ignore-case --hidden --glob "!.git/*" --color "always"'
let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages --glob "!.git/*"'
let g:fzf_preview_split_key_map = 'ctrl-s'
let g:fzf_preview_fzf_color_option= 'bg:235'
let g:fzf_preview_floating_window_winblend = 0
" autocmd VimEnter * let g:fzf_preview_grep_command_options = fzf_preview#command#get_common_command_options() | let g:fzf_preview_grep_command_options = g:fzf_preview_grep_command_options . ' --nth=3'
" nnoremap <silent> <leader>ft :FzfPreviewBufferTags <CR>
" nnoremap <silent> <leader>fc :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
" nnoremap <silent> <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
" nnoremap <silent> <leader>f/     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query=""<CR>
" nnoremap <silent> <leader>f/     :<C-u>FzfPreviewLines<CR>
" nnoremap <silent> <leader>f*     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
" nnoremap <silent> <leader>fb :FzfPreviewBuffers<CR>
" nnoremap <silent> <leader>ff :FzfPreviewProjectFiles <CR>
" nnoremap <silent> <leader>fd :FzfPreviewDirectoryFiles <CR>
" nnoremap <silent> <leader>fg :FzfPreviewGitStatus <CR>
" nnoremap <silent> <leader>fr :<C-u>FzfPreviewProjectGrep -add-fzf-arg=--nth=3<Space>
" nnoremap <silent> <leader>fm :FzfPreviewMarks <CR>
" nnoremap <silent> <leader>fq :FzfPreviewQuickFix <CR>
