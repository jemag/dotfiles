set showmode
set ignorecase
set smartcase
nnoremap R "_d
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
set incsearch
set cindent
inoremap jk <esc>
syntax on
set number relativenumber 
augroup numbertoggle 
	autocmd! 
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber 
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber 
augroup END
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
" Initialize plugin system
call plug#end()
