" For startify
let g:startify_padding_left = 40
let g:startify_session_dir = '~/.cache/nvim/session'
let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']            },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ ]
let g:startify_bookmarks = [
            \ { 'c': '~/.config/i3/config' },
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ ]
let g:startify_session_delete_buffers = 1
let g:startify_enable_special = 0
function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction
let g:startify_session_before_save = [
      \ 'echo "Cleaning up before saving.."',
      \ 'lua require("scrollbar").clear()'
      \ ]

" nnoremap <silent> <leader>s :Startify<CR>
