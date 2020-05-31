nnoremap <silent> <leader>ft :FzfPreviewBufferTags <CR>
nnoremap <silent> <leader>fc :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
" nnoremap <silent> <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
nnoremap <silent> <leader>f/     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query=""<CR>
nnoremap <silent> <leader>f*     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> <leader>fb :FzfPreviewBuffers<CR>
nnoremap <silent> <leader>ff :FzfPreviewProjectFiles <CR>
nnoremap <silent> <leader>fd :FzfPreviewDirectoryFiles <CR>
nnoremap <silent> <leader>fg :FzfPreviewGitStatus <CR>
nnoremap <silent> <leader>fr :<C-u>FzfPreviewProjectGrep -add-fzf-arg=--nth=3<Space>
nnoremap <silent> <leader>fm :FzfPreviewmarks <CR>
nnoremap <silent> <leader>fq :FzfPreviewQuickFix <CR>
" nnoremap <silent> <leader>ft :BTags<CR>
" nnoremap <silent> <leader>fc :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
" nnoremap <silent> <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
" nnoremap <silent> <leader>fb :Buffers<CR>
" nnoremap <silent> <leader>ff :call Fzf_dev()<CR>
" nnoremap <silent> <leader>fr :Find <CR>
" nnoremap <silent> <leader>fw :Find <C-R><C-W><CR>
