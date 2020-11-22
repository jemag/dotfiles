" augroup your_config_scrollbar_nvim
"     autocmd!
"     autocmd BufEnter    * silent! lua require('scrollbar').show()
"     autocmd BufLeave    * silent! lua require('scrollbar').clear()

"     autocmd CursorMoved * silent! lua require('scrollbar').show()
"     autocmd VimResized  * silent! lua require('scrollbar').show()

"     autocmd FocusGained * silent! lua require('scrollbar').show()
"     autocmd FocusLost   * silent! lua require('scrollbar').clear()
" augroup end
augroup ScrollbarInit
  autocmd!
  autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,FocusLost,BufLeave             * silent! lua require('scrollbar').clear()
augroup end

let g:scrollbar_max_size = 10
let g:scrollbar_min_size = 3
  let g:scrollbar_shape = {
    \ 'head': '',
    \ 'body': '█',
    \ 'tail': '',
    \ }

let g:scrollbar_excluded_filetypes = ['nvim-tree', 'fzf', 'defx', 'vista', 'tagbar', 'vifm', 'startify']
