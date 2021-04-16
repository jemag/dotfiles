let g:mapleader = "\<Space>"
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = '-'

" Load plugins
lua require'plugins'

" Disable menu.vim
if has('gui_running')
   set guioptions=Mc
endi


let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
" let g:loaded_man               = 1
let g:loaded_matchit           = 1
" let g:loaded_netrwFileHandlers = 1
" let g:loaded_netrwPlugin       = 1
" let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_shada_plugin      = 1
" let g:loaded_spellfile_plugin  = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1
