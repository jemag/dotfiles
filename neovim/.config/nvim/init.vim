if has('vim_starting')
  source $HOME/.config/nvim/general/initialize.vim
endif
source $HOME/.config/nvim/plugin-configs/deinrc.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/keybindings/mappings.vim
source $HOME/.config/nvim/keybindings/vim-which-key.vim
source $HOME/.config/nvim/themes/theme.vim

call dein#call_hook('source')
call dein#call_hook('post_source')

if &compatible
  set nocompatible
endif

let $VIMPATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let $VARPATH = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache').'/vim')

" Constants
let s:is_sudo = $SUDO_USER !=# '' && $USER !=# $SUDO_USER

function! s:source_file(path, ...) abort
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand($VIMPATH.'/core/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute 'source' fnameescape(tempfile)
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

augroup MyAutoCmd
  autocmd!
  autocmd CursorHold *? syntax sync minlines=300
augroup END


filetype plugin indent on
syntax enable

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"---------------------------------------------------------------------------
if s:is_sudo
  set noswapfile
  set nobackup
  set nowritebackup
  set noundofile
  if has('nvim')
    set shada="NONE"
  else
    set viminfo="NONE"
  endif
endif
