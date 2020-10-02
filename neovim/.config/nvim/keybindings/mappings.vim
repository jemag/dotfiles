" ctrl p/n should act like up down for command line history
cnoremap <C-p> <Up>
noremap <expr> ' printf('`%c zz',getchar())
cnoremap <C-n> <Down>
nnoremap R "_d
" Remove search highlighting
nnoremap <esc> :noh<return><esc>
filetype plugin indent on " show existing tab with spaces width
inoremap jk <esc>
"switch window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
" CTRL-U in insert mode deletes a lot. Put an undo-point before it.
inoremap <C-u> <C-g>u<C-u>

" For toggling spelling
nnoremap <silent> <F11> :set spell!<cr>
inoremap <silent> <F11> <C-O>:set spell!<cr>
" Cycle through buffers
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
"smart move
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k

" Better indentation
vnoremap < <gv
vnoremap > >gv

" Use alt + hjkl to resize windows
nnoremap <silent> <M-j>    :resize -2<CR>
nnoremap <silent> <M-k>    :resize +2<CR>
nnoremap <silent> <M-h>    :vertical resize -2<CR>
nnoremap <silent> <M-l>    :vertical resize +2<CR>

" Add newline above or below
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>
" My remapping of <C-^>. If there is no alternate file, and there's no count given, then switch
" to next file. We use `bufloaded` to check for alternate buffer presence. This will ignore
" deleted buffers, as intended. To get default behaviour, use `bufexists` in it's place.
nnoremap <silent> <C-n> :<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>

"yank to end
nnoremap Y y$

" Navigate neovim + neovim terminal emulator with alt+direction
tnoremap <c-h> <C-\><C-n><C-w>h
tnoremap <c-j> <C-\><C-n><C-w>j
tnoremap <c-k> <C-\><C-n><C-w>k
tnoremap <c-l> <C-\><C-n><C-w>l

" easily escape terminal
tnoremap <C-o> <C-\><C-n><esc><cr>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
