let g:indentLine_enabled = 0
let g:indentline_char='┆'
let g:indentLine_fileTypeExclude = ['defx', 'denite','startify','tagbar','vista', 'vifm']
let g:indentLine_concealcursor = 'niv'
let g:indentLine_color_term = 96
let g:indentLine_color_gui= '#725972'
let g:indentLine_showFirstIndentLevel =1
" augroup indentline_toggle
"   autocmd!
"   autocmd CmdwinEnter,CmdlineEnter * let g:indentLine_enabled=0
"   autocmd CmdwinLeave,CmdlineLeave * let g:indentLine_enabled=1
" augroup END
