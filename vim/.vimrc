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
" Initialize plugin system
call plug#end()
set noshowmode
set ignorecase
set smartcase
nnoremap R "_d
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
set incsearch
set cindent
inoremap jk <esc>
syntax enable
colorscheme darcula
set background=dark
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
set t_Co=256
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'
set number relativenumber 
augroup numbertoggle 
	autocmd! 
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber 
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber 
augroup END
