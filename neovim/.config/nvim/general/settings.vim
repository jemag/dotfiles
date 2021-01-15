set exrc
set nobackup
set noswapfile
set autoread
set autowrite
set confirm
set splitbelow
set bsdir=buffer
set nofoldenable
set wildmode=full
set inccommand=split
set textwidth=0
set nowrap
set scrolloff=8
" enable mouse
set mouse=a
if has('vim_starting')
	set encoding=UTF-8
	scriptencoding UTF-8
endif
set laststatus=2
" show column with ctrl+g
set noruler
set showtabline=2
" set statusline=-        " hide file name in statusline
set fillchars+=vert:\|  " add a bar for vertical splits
if get(g:,'gruvbox_transp_bg',1)
 set fcs=eob:\           " hide ~
endif

" if has('clipboard')
"	set clipboard& clipboard+=unnamedplus
" endif

" spelling
set spelllang=en,fr
" enable embedded syntax highlighting
let g:vimsyn_embed='lPr'

set history=2000
set number
set timeout ttimeout
set cmdheight=1         " Height of the command line
set timeoutlen=500
set ttimeoutlen=10
set updatetime=50
set undofile
set undodir=~/.tmp/undo
set relativenumber
set backspace=2
set backspace=indent,eol,start
" Tabs and Indents {{{
" ----------------
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set autoindent
set cindent
set shiftround
" }}}
set hidden
set shortmess=aFc
set signcolumn=yes
set completefunc=emoji#complete
set completeopt =menuone,noinsert,noselect
set nolist
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set grepprg=rg\ --vimgrep\ --hidden\ $*
set wildignore+=*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*

set conceallevel=0

" Create file's directory before saving, if it doesn't exist.
" Original: https://stackoverflow.com/a/4294176/151048
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
fun! s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
    call mkdir(fnamemodify(a:file, ':h'), 'p')
  endif
endfun

" Neovim highlight yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=false}
  augroup END

" Background colors for active vs inactive windows
" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of active/inactive windows
function! Handle_Win_Enter()
  " hi InactiveWindow guibg=#0D1B22
  hi InactiveWindow guibg=#1C1C1C
  setlocal winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
endfunction

" Better auto completion with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
