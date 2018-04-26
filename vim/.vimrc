" vim plug section
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes
" Any valid git URL is allowed
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/vim-scripts/ReplaceWithRegister'
Plug 'https://github.com/christoomey/vim-titlecase'
Plug 'https://github.com/christoomey/vim-sort-motion'
Plug 'https://github.com/christoomey/vim-system-copy'
Plug 'https://github.com/blueshirts/darcula'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/leafgarland/typescript-vim'
Plug 'w0rp/ale'
Plug 'ajh17/vimcompletesme'
Plug 'https://github.com/ryanoasis/vim-devicons'
call plug#end()


" leader as spacebar
let mapleader =" "
set guifont=Menlo\ for\ Powerline
set encoding=utf-8
set noshowmode
set ignorecase
set smartcase
nnoremap R "_d
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
set incsearch
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=2
 " when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab
inoremap jk <esc>
syntax enable
colorscheme darcula
set background=dark
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
set t_Co=256
set number relativenumber 
" show real line numbers in insert mode
augroup numbertoggle 
	autocmd! 
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber 
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber 
augroup END

" nerd tree
map <leader>r :NERDTreeFind<cr>
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" air-line
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" webdevicons
let g:Powerline_symbols = 'unicode'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
