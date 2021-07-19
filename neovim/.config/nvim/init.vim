if has('vim_starting')
  source $HOME/.config/nvim/general/initialize.vim
endif
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/keybindings/mappings.vim
source $HOME/.config/nvim/themes/theme.vim

augroup gui
  autocmd!
  autocmd UIEnter * GuiFont! FuraCode\ Nerd\ Font\ Mono:h9
augroup END

if &compatible
  set nocompatible
endif

" Constants
let s:is_sudo = $SUDO_USER !=# '' && $USER !=# $SUDO_USER

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
