" ctrl p/n should act like up down for command line history
cnoremap <C-p> <Up>
nnoremap ' `
cnoremap <C-n> <Down>
nnoremap R "_d
" Remove search highlighting
nnoremap <esc> :noh<return><esc>
filetype plugin indent on " show existing tab with spaces width
inoremap jk <esc>
" Buffer
nnoremap bn :bnext<CR>
nnoremap bp :bprevious<CR>
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

"smart move
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k


" My remapping of <C-^>. If there is no alternate file, and there's no count given, then switch
" to next file. We use `bufloaded` to check for alternate buffer presence. This will ignore
" deleted buffers, as intended. To get default behaviour, use `bufexists` in it's place.
nnoremap <silent> <C-n> :<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>

"tabline operation
nmap <leader>tn :tabnew<cr>
nmap <leader>te :tabedit
nmap <leader>tm :tabmove

"yank to end
nnoremap Y y$

" Navigate neovim + neovim terminal emulator with alt+direction
tnoremap <c-h> <C-\><C-n><C-w>h
tnoremap <c-j> <C-\><C-n><C-w>j
tnoremap <c-k> <C-\><C-n><C-w>k
tnoremap <c-l> <C-\><C-n><C-w>l

" easily escape terminal
tnoremap <C-o> <C-\><C-n><esc><cr>

nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)
