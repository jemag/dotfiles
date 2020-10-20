" -----------------------------------------------------------------------------
" Name:           Halcyon Theme
" Author:         Tiger Nie <nhl0819@gmail.com>
" Website:        https://github.com/NieTiger/halcyon-neovim
" License:        MIT
" ----------------------------------------------------------------------------- 
" Initialisation: {{{
highlight clear
if exists('syntax_on')
  syntax reset
endif

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

let g:colors_name = 'halcyon'
set background=dark
" Custom modif by me, set background color

function! s:GuiFor(group, ...)
  let histring = 'hi ' . a:group . ' ctermfg=NONE ctermbg=NONE cterm=NONE '

  if strlen(a:1)
    let histring .= 'guibg=' . a:1 . ' '
  endif

  if strlen(a:2)
    let histring .= 'guifg=' . a:2 . ' '
  endif

  if a:0 >= 3 && strlen(a:3)
    let histring .= 'gui=' . a:3 . ' '
  endif

  execute histring
endfunction
"}}}

" Color Configuration:{{{
let s:WORKBENCH = '#171c28'
let s:BLACK = s:WORKBENCH
let s:BACKGROUND = '#1d2433'
let s:FOREGROUND = '#a2aabc'
let s:UI_GREY = '#6679a4'
let s:ACCENT = '#ffcc66'
let s:RED = '#ef6b73'
let s:GREEN = '#bae67e'
let s:YELLOW = '#ffd580'
let s:ORANGE = '#ffae57'
let s:BLUE = '#5ccfe6'
let s:CYAN = s:BLUE
let s:PURPLE = '#c3a6ff'
let s:MAGENTA = s:PURPLE
let s:WHITE = '#d7dce2'
let s:LIGHT_GREY = '#8695b7'
let s:GREY = '#2f3b54'
let s:DARK_GREY = '#1d2433'"}}}

" Default
call s:GuiFor('Normal', 'NONE', s:FOREGROUND)

" --------------------------------------------------
" Keywords, constants, template literals, purple
" --------------------------------------------------
call s:GuiFor("Constant", "NONE", s:PURPLE)
call s:GuiFor('Keyword', 'NONE', s:PURPLE)
call s:GuiFor('Number', 'NONE', s:PURPLE)
call s:GuiFor('Repeat', 'NONE', s:PURPLE)
call s:GuiFor('Special', 'NONE', s:PURPLE)
call s:GuiFor('SpecialKey', 'NONE', 'NONE')
call s:GuiFor('Statement', 'NONE', s:PURPLE, 'NONE')
call s:GuiFor('Tag', 'NONE', s:PURPLE)
call s:GuiFor('Type', 'NONE', s:PURPLE, 'NONE')
call s:GuiFor('Typedef', 'NONE', s:PURPLE, 'NONE')

" --------------------------------------------------
" Functions, classes, object literal keys, yellow
" --------------------------------------------------
call s:GuiFor('Directory', 'NONE', s:YELLOW)
call s:GuiFor('Function', 'NONE', s:YELLOW)
call s:GuiFor('PreProc', 'NONE', s:YELLOW)
call s:GuiFor('StorageClass', 'NONE', s:YELLOW)

" --------------------------------------------------
" Constants, operators, orange
" --------------------------------------------------
call s:GuiFor('Conditional', 'NONE', s:ORANGE)
call s:GuiFor('Exception', 'NONE', s:ORANGE)
call s:GuiFor('Include', 'NONE', s:ORANGE)
call s:GuiFor('Macro', 'NONE', s:ORANGE)
call s:GuiFor('Operator', 'NONE', s:ORANGE)
call s:GuiFor('PreCondit', 'NONE', s:ORANGE)

" --------------------------------------------------
" Strings, markdown headings, green
" --------------------------------------------------
call s:GuiFor('CursorLineNR', 'NONE', s:GREEN)
call s:GuiFor('Debug', 'NONE', s:GREEN)
call s:GuiFor('Define', 'NONE', s:GREEN)
call s:GuiFor('Delimiter', 'NONE', s:GREEN)
call s:GuiFor('DiffChange', 'NONE', s:GREEN, 'NONE')
call s:GuiFor('GREENing', 'NONE', s:GREEN)
call s:GuiFor('Label', 'NONE', s:GREEN)
call s:GuiFor('MoreMsg', 'NONE', s:GREEN)
call s:GuiFor('Title', 'NONE', s:GREEN, 'NONE')
call s:GuiFor('Todo', 'NONE', s:GREEN)

call s:GuiFor('GitGutterChange', 'NONE', s:GREEN)

call s:GuiFor('MatchParen', s:ORANGE, s:ORANGE)

" --------------------------------------------------
" Special keywords, classes, markdown code blocks, blue
" --------------------------------------------------
call s:GuiFor('Identifier ', 'NONE', s:BLUE)
call s:GuiFor('SpecialChar', 'NONE', s:BLUE)
call s:GuiFor('DiffAdd', 'NONE', s:BLUE, 'NONE')

call s:GuiFor('Conceal', 'NONE', s:BLUE, 'NONE')

" --------------------------------------------------
" Status bar text, buttons, etc, grey
" --------------------------------------------------
call s:GuiFor('Comment', 'NONE', s:LIGHT_GREY, "italic")
call s:GuiFor('NonText', 'NONE', s:LIGHT_GREY)
call s:GuiFor('SpecialComment', 'NONE', s:LIGHT_GREY)
call s:GuiFor('LineNr', 'NONE', s:GREY)
call s:GuiFor('StatusLine', 'NONE', s:FOREGROUND, 'NONE')
call s:GuiFor('StatusLineNC', s:FOREGROUND, 'NONE')

" --------------------------------------------------
" Deletion highlights, errors, warnings, red
" --------------------------------------------------
call s:GuiFor('DiffDelete', 'NONE', s:RED, 'NONE')
call s:GuiFor('DiffText', 'NONE', s:RED, 'NONE')
call s:GuiFor('Error', 'NONE', s:RED)
call s:GuiFor('ErrorMsg', 'NONE', s:RED)
call s:GuiFor('GitGutterChangeREDete', 'NONE', s:RED)
call s:GuiFor('GitGutterREDete', 'NONE', s:RED)
call s:GuiFor('WarningMsg', 'NONE', s:RED)
call s:GuiFor('Question', 'NONE', s:RED, 'NONE')

" --------------------------------------------------
" Modified highlights (mod) cyan
" --------------------------------------------------
call s:GuiFor('SignColumn ', 'NONE', s:CYAN, 'NONE')
call s:GuiFor('CursorLine ', 'NONE', s:CYAN, 'NONE')

" --------------------------------------------------
" Complex
" --------------------------------------------------
call s:GuiFor('Visual', s:GREY, 'NONE')
call s:GuiFor('VertSplit', 'NONE', s:BACKGROUND, 'NONE')
call s:GuiFor('EndOfBuffer', 'NONE', s:BACKGROUND, 'NONE')

call s:GuiFor('Pmenu', s:BACKGROUND, s:FOREGROUND)
call s:GuiFor('PMenuSel', 'NONE', s:ORANGE)
"call s:GuiFor('PMenuSbar', 'NONE', s:ORANGE)
"call s:GuiFor('PMenuThumb', 'NONE', s:ORANGE)

call s:GuiFor('WildMenu', s:CYAN, s:BACKGROUND)

call s:GuiFor('TabLine', 'NONE', s:FOREGROUND, 'NONE')
call s:GuiFor('TabLineFill', 'NONE', 'NONE', 'NONE')
call s:GuiFor('TabLineSel', s:BACKGROUND, s:FOREGROUND, 'NONE')

call s:GuiFor('Folded', s:WORKBENCH, s:FOREGROUND)
call s:GuiFor('FoldColumn', 'NONE', s:FOREGROUND)

call s:GuiFor('GitGutterAdd', 'NONE', s:PURPLE)

call s:GuiFor('IncSearch', 'NONE', s:FOREGROUND)
call s:GuiFor('Search', s:GREY, 'NONE')

" --------------------------------------------------
" sh
" --------------------------------------------------

call s:GuiFor('shDoubleQuote', 'NONE', s:GREEN)
call s:GuiFor('shCommandSubBQ', 'NONE', s:GREEN)
call s:GuiFor('shQuote', 'NONE', s:GREEN)

" --------------------------------------------------
" JavaScript 'pangloss/vim-javascript'
" --------------------------------------------------

call s:GuiFor('jsVariableDef', 'NONE', s:CYAN)
call s:GuiFor('jsGlobalObjects', 'NONE', s:CYAN)
call s:GuiFor('jsStorageClass', 'NONE', s:PURPLE)
call s:GuiFor('jsTemplateString', 'NONE', s:GREEN)
call s:GuiFor('jsString', 'NONE', s:GREEN)
call s:GuiFor('jsForAwait', 'NONE', s:ORANGE)
call s:GuiFor('jsDot', 'NONE', s:ORANGE)

" --------------------------------------------------
" CSS
" --------------------------------------------------

call s:GuiFor('cssClassName', 'NONE', s:ORANGE)
call s:GuiFor('cssClassNameDot', 'NONE', s:ORANGE)
call s:GuiFor('cssColor', 'NONE', s:ORANGE)
call s:GuiFor('cssBorderProp', 'NONE', s:BLUE)
call s:GuiFor('cssBoxProp', 'NONE', s:BLUE)
call s:GuiFor('cssBackgroundProp', 'NONE', s:ORANGE)
call s:GuiFor('cssPseudoClassId', 'NONE', s:ORANGE)
call s:GuiFor('cssBraces', 'NONE', s:FOREGROUND)
call s:GuiFor('cssFlexibleBoxProp', 'NONE', s:BLUE)
call s:GuiFor('cssFontProp', 'NONE', s:BLUE)
call s:GuiFor('cssIdentifier ', 'NONE', s:BLUE)
call s:GuiFor('cssImportant', 'NONE', s:BLUE)
call s:GuiFor('cssMediaProp', 'NONE', s:BLUE)
call s:GuiFor('cssPositioningProp', 'NONE', s:BLUE)
call s:GuiFor('cssTagName', 'NONE', s:BLUE)
call s:GuiFor('cssTextProp', 'NONE', s:BLUE)
call s:GuiFor('cssUIProp', 'NONE', s:BLUE)
call s:GuiFor('cssAttr', 'NONE', s:PURPLE)
call s:GuiFor('cssIncludeKeyword ', 'NONE', s:PURPLE)
call s:GuiFor('cssUnitDecorators', 'NONE', s:PURPLE)
call s:GuiFor('cssStringQ', 'NONE', s:GREEN)
call s:GuiFor('cssStringQQ', 'NONE', s:GREEN)

" --------------------------------------------------
" SCSS
" --------------------------------------------------

call s:GuiFor('sassVariable', 'NONE', s:FOREGROUND)
call s:GuiFor('sassClass', 'NONE', s:ORANGE)

" --------------------------------------------------
" HTML
" --------------------------------------------------

call s:GuiFor('htmlArg', 'NONE', s:ORANGE)
call s:GuiFor('htmlString', 'NONE', s:GREEN)
call s:GuiFor('htmlTagName', 'NONE', s:CYAN)
call s:GuiFor('htmlTag', 'NONE', s:FOREGROUND)
call s:GuiFor('htmlTagEndTag', 'NONE', s:FOREGROUND)
call s:GuiFor('htmlEvent', 'NONE', s:ORANGE)

" --------------------------------------------------
" Python 'vim-python/python-syntax'
" --------------------------------------------------

call s:GuiFor('pythonString', 'NONE', s:GREEN)
call s:GuiFor('pythonRawString', 'NONE', s:GREEN)

" --------------------------------------------------
" C
" --------------------------------------------------

call s:GuiFor('cStatement', 'NONE', s:ORANGE)
call s:GuiFor('cIncluded', 'NONE', s:GREEN)
call s:GuiFor('cString', 'NONE', s:GREEN)

" --------------------------------------------------
" Golang 'fatih/vim-go'
" --------------------------------------------------

call s:GuiFor('goString', 'NONE', s:GREEN)
call s:GuiFor('goStatement', 'NONE', s:ORANGE)
call s:GuiFor('goBuiltins', 'NONE', s:YELLOW)

" --------------------------------------------------
" YAML
" --------------------------------------------------

call s:GuiFor('yamlFlowString', 'NONE', s:GREEN)
call s:GuiFor('yamlFlowStringDelimiter', 'NONE', s:GREEN)

" --------------------------------------------------
" Markdown
" --------------------------------------------------

call s:GuiFor('mkdHeading', 'NONE', s:GREEN)
call s:GuiFor('mkdCode', 'NONE', s:CYAN)
call s:GuiFor('mkdCodeDelimiter', 'NONE', s:CYAN)
call s:GuiFor('mkdCodeStart', 'NONE', s:CYAN)
call s:GuiFor('mkdCodeEnd', 'NONE', s:CYAN)
call s:GuiFor('mkdLink', 'NONE', s:YELLOW)
call s:GuiFor('mkdURL', 'NONE', s:PURPLE)

call s:GuiFor('markdownLinkText', 'NONE', s:YELLOW)

" ==================================================
" Built-in Terminal
" --------------------------------------------------
call s:GuiFor('Terminal', 'NONE', s:FOREGROUND)
if has('nvim')
  let g:terminal_color_0 = s:WORKBENCH
  let g:terminal_color_8 = s:BACKGROUND
  let g:terminal_color_1 = s:RED
  let g:terminal_color_9 = s:RED

  let g:terminal_color_2 = s:GREEN
  let g:terminal_color_10 = s:GREEN

  let g:terminal_color_3 = s:YELLOW
  let g:terminal_color_11 = s:YELLOW

  let g:terminal_color_4 = s:BLUE
  let g:terminal_color_12 = s:BLUE

  let g:terminal_color_5 = s:MAGENTA
  let g:terminal_color_13 = s:MAGENTA

  let g:terminal_color_6 = s:CYAN
  let g:terminal_color_14 = s:CYAN
  
  let g:terminal_color_7 = s:WHITE
  let g:terminal_color_15 = s:WHITE

elseif exists('*term_setansicolors')
  let g:terminal_ansi_colors = [
    \ s:BLACK,
    \ s:RED,
    \ s:GREEN,
    \ s:YELLOW,
    \ s:BLUE,
    \ s:MAGENTA,
    \ s:CYAN,
    \ s:WHITE,
    \ s:BLACK,
    \ s:RED,
    \ s:GREEN,
    \ s:YELLOW,
    \ s:CYAN,
    \ s:MAGENTA,
    \ s:BLUE,
    \ s:WHITE,
    \ ]
endif

" ==================================================
" Lightline
"" --------------------------------------------------
if exists('g:lightline')
    let s:p = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {} }

    let s:p.normal.left = [[s:BLACK, s:CYAN], [s:FOREGROUND, s:GREY]]
    let s:p.normal.right = [[s:BLACK, s:CYAN], [s:FOREGROUND, s:GREY]]
    let s:p.normal.middle = [[s:FOREGROUND, s:BACKGROUND]]
    let s:p.normal.error = [[s:FOREGROUND, s:RED]]
    let s:p.normal.warning = [[s:FOREGROUND, s:ORANGE]]

    let s:p.insert.left = [[s:BLACK, s:GREEN], [s:FOREGROUND, s:DARK_GREY]]
    let s:p.insert.right = [[s:BLACK, s:GREEN], [s:FOREGROUND, s:DARK_GREY]]

    let s:p.replace.left = [[s:BLACK, s:RED], [s:FOREGROUND, s:DARK_GREY]]
    let s:p.replace.right = [[s:BLACK, s:RED], [s:FOREGROUND, s:DARK_GREY]]

    let s:p.visual.left = [[s:BLACK, s:YELLOW], [s:FOREGROUND, s:DARK_GREY]]
    let s:p.visual.right = [[s:BLACK, s:YELLOW], [s:FOREGROUND, s:DARK_GREY]]

    let s:p.inactive.left =  [[s:FOREGROUND, s:DARK_GREY], [s:FOREGROUND, s:DARK_GREY]]
    let s:p.inactive.right = [[s:FOREGROUND, s:DARK_GREY], [s:FOREGROUND, s:DARK_GREY]]
    let s:p.inactive.middle = [[s:FOREGROUND, s:GREY]]

    let s:p.tabline.left = [[s:FOREGROUND, s:GREY]]
    let s:p.tabline.right = [[s:BLACK, s:CYAN]]
    let s:p.tabline.middle = [[s:FOREGROUND, s:GREY]]
    let s:p.tabline.tabsel = [[s:BLACK, s:CYAN]]

    let g:lightline#colorscheme#halcyon#palette = lightline#colorscheme#fill(s:p)
endif
highlight Normal guibg=#1d2433
