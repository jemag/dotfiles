set showmode
set ignorecase
set smartcase
nnoremap R "_d
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
set incsearch
set cindent
:inoremap jk <esc>
syntax on
set number
