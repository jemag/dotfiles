let g:neoterm_autoscroll = 1
let g:neoterm_autoinsert = 1

if dein#tap('neoterm')
  " quickly toggle term
  nnoremap <silent> <leader>tv :vertical botright Ttoggle<cr>
  nnoremap <silent> <leader>th :botright Ttoggle<cr>

  nnoremap <silent> <F9> :botright Ttoggle<cr>
  tnoremap <silent> <F9> <C-\><C-n><esc><cr>:Ttoggle<CR>
endif
