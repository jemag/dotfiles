" Theme

" Enable 256 color terminal
set t_Co=256

" Enable true color
if has('termguicolors')
	set termguicolors
endif

set background=dark

" let g:gruvbox_filetype_hi_groups = 1
" let g:gruvbox_plugin_hi_groups = 1
" let g:gruvbox_transp_bg = 1
" let g:gruvbox_italicize_strings = 0
" colorscheme hybrid_reverse
"colorscheme space_vim_theme
" colorscheme PaperColor
"colorscheme gruvbox8
"colorscheme dracula
"colorscheme  solarized8
colorscheme  gruvbox

" Vim Colors
" ---------------------------------------------------------
hi Whitespace ctermfg=96 guifg=#725972 guibg=NONE ctermbg=NONE
hi VertSplit  ctermfg=Black  guifg=Black
"hi Normal guibg=NONE ctermbg=NONE
"hi LineNr ctermbg=NONE guibg=NONE
"hi SignColumn ctermfg=187 ctermbg=NONE guifg=#ebdbb2 guibg=NONE guisp=NONE cterm=NONE gui=NONE
highlight! link pythonSpaceError  NONE
highlight! link pythonIndentError NONE

"Pmenu Colors
" ---------------------------------------------------------
hi PMenuSel ctermfg=252 ctermbg=106 guifg=#d0d0d0 guibg=#859900 guisp=#859900 cterm=NONE gui=NONE

"coc highlight setting
" ---------------------------------------------------------
hi default CocHighlightText  guibg=#725972 ctermbg=96
hi CocWarningSign  ctermfg=32 ctermbg=NONE guifg=#0087d7 guibg=NONE


"GitGutter Coc-git Highlight
" ---------------------------------------------------------
highlight GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE guibg=NONE
highlight GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE guibg=NONE
highlight GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
highlight GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE

" buftabline highlight
" ---------------------------------------------------------
highlight BufTabLineCurrent ctermbg=96 guibg=#5d4d7a
