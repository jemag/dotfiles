" VIM PLUG SECTION
" check if vim plug is installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

let g:coc_global_extensions = [
      \'coc-yaml',
      \'coc-json',
      \'coc-html',
      \'coc-pyls',
      \'coc-java',
      \'coc-emmet',
      \'coc-highlight',
      \'coc-snippets',
      \'coc-tsserver',
      \'coc-css']
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Make sure you use single quotes
" Any valid git URL is allowed
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/vim-scripts/ReplaceWithRegister'
Plug 'https://github.com/christoomey/vim-titlecase'
Plug 'https://github.com/christoomey/vim-sort-motion'
Plug 'https://github.com/christoomey/vim-system-copy'
" Plug 'https://github.com/blueshirts/darcula'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/leafgarland/typescript-vim'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'https://github.com/jiangmiao/auto-pairs'
"Plug 'https://github.com/ludovicchabant/vim-gutentags'
"Plug 'https://github.com/Quramy/tsuquyomi'
Plug 'https://github.com/drewtempelmeyer/palenight.vim'
Plug 'https://github.com/reedes/vim-pencil'
Plug 'https://github.com/airblade/vim-gitgutter'
Plug 'https://github.com/tpope/vim-repeat'
Plug 'majutsushi/tagbar'
Plug 'https://github.com/airblade/vim-rooter'
Plug 'https://github.com/christoomey/vim-tmux-navigator'
Plug 'tpope/vim-markdown'
"'Plug 'https://github.com/shime/vim-livedown'
"Plug 'https://github.com/suan/vim-instant-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'https://github.com/jtratner/vim-flavored-markdown'
Plug 'https://github.com/nelstrom/vim-markdown-folding'
Plug 'https://github.com/junegunn/goyo.vim'
Plug 'https://github.com/tpope/vim-unimpaired'
call plug#end()



" load other buffers without saving current one
set hidden
" leader as spacebar
let mapleader =" "
set encoding=utf-8
set noshowmode
set ignorecase
set smartcase
" save more ex commands
set history=200
" ctrl p/n should act like up down for command line history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nnoremap R "_d
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
set incsearch
set hlsearch
nnoremap <esc> :noh<return><esc>
filetype plugin indent on " show existing tab with 4 spaces width
:nnoremap <C-z> <C-a>
set tabstop=2
 " when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab
inoremap jk <esc>
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

" youCompleteMe
"let g:ycm_autoclose_preview_window_after_insertion = 5
"let g:ycm_autoclose_preview_window_after_completion = 1

" tsuquyomi
let g:tsuquyomi_single_quote_import = 1
nnoremap <leader>I :TsuImport <CR>

" fzf
nnoremap <leader><C-n> :Files<CR>
nnoremap <leader><Tab> :Buffers<CR>
nnoremap <leader><C-f> :Ag<CR>

" nerd tree
map <leader>r :NERDTreeFind<cr>
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" air-line
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1

" tagbar
nmap <leader>T :TagbarToggle<CR>

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
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif
" instat_markdown_preview
" use :InstantMarkdownPreview to start instead of automatic
let g:instant_markdown_autostart = 0

"COC.nvim settings

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> <C-q> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
