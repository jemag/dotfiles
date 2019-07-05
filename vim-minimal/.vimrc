"============================
" General
"============================


" Allow loading of other buffers without saving current one
set hidden
set encoding=utf-8
set noshowmode
set ignorecase
set smartcase
" save more ex commands
set history=200
set incsearch
set hlsearch
 " when indenting with '>', use 2 spaces width
set shiftwidth=2
set tabstop=2
" On pressing tab, insert spaces
set expandtab
syntax enable

colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='soft'
set t_Co=256

set number relativenumber
" show real line numbers in insert mode
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END


"============================
" Keybindings
"============================


" leader as spacebar
let mapleader =" "
" ctrl p/n should act like up down for command line history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nnoremap R "_d
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
" Remove search highlighting
nnoremap <esc> :noh<return><esc>
filetype plugin indent on " show existing tab with spaces width
nnoremap <C-z> <C-a>
inoremap jk <esc>
" Buffer
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
