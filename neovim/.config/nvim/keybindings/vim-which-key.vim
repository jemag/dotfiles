" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :silent <c-u> :silent WhichKey '-'<CR>
vnoremap <silent> <localleader> :silent <c-u> :silent WhichKeyVisual '-'<CR>

" Create map to add keys to
let g:which_key_map =  {}
let g:which_key_localmap = {}
" Define a separator
let g:which_key_sep = '→'

let g:which_key_map['.'] = [ ':e $MYVIMRC',             'Open init' ]
let g:which_key_map[';'] = [ ':Commands',               'Commands' ]
let g:which_key_map[','] = [ 'Startify',                'Start screen' ]
let g:which_key_map['e'] = [ ':LuaTreeToggle',          'Explorer' ]
let g:which_key_map['S'] = [ ':SSave',                  'Save session' ]
let g:which_key_map['L'] = [ ':SLoad',                  'Load session' ]
let g:which_key_map['G'] = [ 'Goyo',                    'Zen' ]
let g:which_key_map['1'] = [ ':BufferGoto 1',  'Buf 1']
let g:which_key_map['2'] = [ ':BufferGoto 2',  'Buf 2']
let g:which_key_map['3'] = [ ':BufferGoto 3',  'Buf 3']
let g:which_key_map['4'] = [ ':BufferGoto 4',  'Buf 4']
let g:which_key_map['5'] = [ ':BufferGoto 5',  'Buf 5']
let g:which_key_map['6'] = [ ':BufferGoto 6',  'Buf 6']
let g:which_key_map['7'] = [ ':BufferGoto 7',  'Buf 7']
let g:which_key_map['8'] = [ ':BufferGoto 8',  'Buf 8']
let g:which_key_map['9'] = [ ':BufferGoto 9',  'Buf 9']
let g:which_key_map['0'] = [ ':BufferGoto 10', 'Buf 10']

let g:which_key_map.b = {
      \ 'name' : '+buffer',
      \ 'd' : [':BufferClose',              'Delete-buffer']   ,
      \ 'D' : [':BufferCloseAllButCurrent', 'Delete all other buffers']   ,
      \ 'e' : ['blast',                     'Last-buffer']     ,
      \ 'f' : ['bfirst',                    'First-buffer']    ,
      \ 'h' : [':BufferMovePrevious',       'move prev'],
      \ 'l' : [':BufferMoveNext',           'move next'],
      \ 'r' : [':BufferCloseBuffersRight',  'delete buffers to the right'],
      \ 'S' : ['Startify',                  'Startify']     ,
      \ 'n' : ['bnext',                     'Next-buffer']     ,
      \ 'p' : ['bprevious',                 'Previous-buffer'] ,
      \ 's' : [':BufferPick',               'Magic buffer select'] ,
      \ '?' : ['Buffers',                   'Fzf-buffer']      ,
      \ }

let g:which_key_map.d = {
      \ 'name' : '+debug' ,
      \ 'b' :      'Breakpoint',
      \ 'B' :      'Conditional breakpoint',
      \ 'l' :      'Repl run last',
      \ 'p' :      'Breakpoint with log',
      \ 'r' :      'Repl open',
      \ }
" let g:which_key_map.c = {
"       \ 'name' : '+coc',
"       \ '.' : [':CocConfig',                        'Config'],
"       \ ';' : ['<Plug>(coc-refactor)',              'Refactor'],
"       \ 'a' : ['<Plug>(coc-codeaction)',            'Line action'],
"       \ 'A' : ['<Plug>(coc-codeaction-selected)',   'Selected action'],
"       \ 'b' : [':CocNext',                          'Next action'],
"       \ 'B' : [':CocPrev',                          'Prev action'],
"       \ 'c' : [':CocList commands',                 'Commands'],
"       \ 'd' : [':CocList diagnostics',              'Diagnostics'],
"       \ 'e' : [':CocList extensions',               'Extensions'],
"       \ 'h' : ['<Plug>(coc-float-hide)',            'Hide'],
"       \ 'I' : [':CocList diagnostics',              'Diagnostics'],
"       \ 'j' : ['<Plug>(coc-float-jump)',            'Float jump'],
"       \ 'l' : ['<Plug>(coc-codelens-action)',       'Code lens'],
"       \ 'n' : ['<Plug>(coc-diagnostic-next)',       'Next diagnostic'],
"       \ 'N' : ['<Plug>(coc-diagnostic-next-error)', 'Next error'],
"       \ 'o' : ['<Plug>(coc-openlink)',              'Open link'],
"       \ 'O' : [':CocList outline',                  'Outline'],
"       \ 'p' : ['<Plug>(coc-diagnostic-prev)',       'Prev diagnostic'],
"       \ 'P' : ['<Plug>(coc-diagnostic-prev-error)', 'Prev error'],
"       \ 'q' : ['<Plug>(coc-fix-current)',           'Quickfix'],
"       \ 'R' : ['<Plug>(coc-rename)',                'Rename'],
"       \ 's' : [':CocList -I symbols',               'Symbols'],
"       \ 'S' : [':CocList snippets',                 'Snippets'],
"       \ 'u' : [':CocListResume',                    'Resume list'],
"       \ 'U' : [':CocUpdate',                        'Update CoC'],
"       \ 'v' : [':Vista!!',                          'Tag viewer'],
"       \ 'z' : [':CocDisable',                       'Disable CoC'],
"       \ 'Z' : [':CocEnable',                        'Enable CoC'],
"       \ }

let g:which_key_map.f = {
      \ 'name' : '+format' ,
      \ 'f' : ['<Plug>(coc-format-selected)', 'Format selected'],
      \ 'F' :           'Format',
      \ 'e' : ['<Plug>(EasyAlign)',           'Easy align'],
      \ }

let g:which_key_localmap.g = {
      \ 'name' : '+git',
      \ 'a' : [':Git add .',                 'Add all'],
      \ 'A' : [':Git add %',                 'Add current'],
      \ 'b' : [':Git blame',                 'Blame'],
      \ 'B' : [':GBrowse',                   'Browse'],
      \ 'c' : [':Git commit',                'Commit'],
      \ 'd' : [':Git diff',                  'Diff'],
      \ 'D' : [':Gdiffsplit',                'Diff split'],
      \ 's' : [':Git',                       'Status'],
      \ 'i' : ['<Plug>(GitGutterPreviewHunk)',  'Chunk info'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)',  'Next chunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)',  'Prev chunk'],
      \ 'l' : [':Git log',                   'Log'],
      \ 'p' : [':Git push',                  'Push'],
      \ 'P' : [':Git pull',                  'Pull'],
      \ 'r' : [':GRemove',                   'Remove'],
      \ 'S' : ['<Plug>(GitGutterStageHunk)', 'Stage chunk'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)',  'Undo chunk'],
      \ 'v' : [':GV',                        'View commits'],
      \ 'V' : [':GV!',                       'View buffer commits'],
      \ }

      " \ 'S' : [':CocCommand git.chunkStage', 'Stage chunk'],
      " \ 'u' : [':CocCommand git.chunkUndo',  'Undo chunk'],
      " \ 'i' : ['<Plug>(coc-git-chunkinfo)',  'Chunk info'],
      " \ 'j' : ['<Plug>(coc-git-nextchunk)',  'Next chunk'],
      " \ 'k' : ['<Plug>(coc-git-prevchunk)',  'Prev chunk'],

" let g:which_key_map.g = {
"       \ 'name' : '+go' ,
"       \ 'd' : ['<Plug>(coc-definition)',      'Definition'],
"       \ 'D' : ['<Plug>(coc-declaration)',     'Declaration'],
"       \ 'y' : ['<Plug>(coc-type-definition)', 'Type definition'],
"       \ 'i' : ['<Plug>(coc-implementation)',  'Implementation'],
"       \ 'r' : ['<Plug>(coc-references)',      'References'],
"       \ }

let g:which_key_map.l = {
      \ 'name' : '+language' ,
      \ 'd' :      'Definition',
      \ 'D' :      'Declaration',
      \ 'h' :      'Hover',
      \ 'i' :      'Implementation',
      \ 'l' :      'Show line diagnostics',
      \ 'n' :      'Next diagnostic',
      \ 'N' :      'Previous diagnostic',
      \ 'r' :      'References',
      \ 'R' :      'Rename',
      \ 's' :      'Signature help',
      \ 't' :      'Type definition',
      \ 'w' :      'Document symbol',
      \ 'W' :      'Workspace symbol',
      \ }


let g:which_key_map.m = {
      \ 'name' : '+bookmarks',
      \ 'm' : [':BookmarkToggle',  'Toggle'],
      \ 'i' : [':BookmarkAnnotate',  'Annotate'],
      \ 'n' : [':BookmarkNext',      'Next bookmark'],
      \ 'p' : [':BookmarkPrev',      'Prev bookmark'],
      \ 'a' : [':BookmarkShowAll',   'Show all'],
      \ 'c' : [':BookmarkClear',     'Clear'],
      \ 'x' : [':BookmarkClearAll',  'Clear all'],
      \ 'k' : [':BookmarkMoveUp',   'Move up'],
      \ 'j' : [':BookmarkMoveDown', 'Move down'],
      \ }

let g:which_key_map.r = {
      \ 'name' : '+refactor',
      \ 'r' : ['<Plug>(Scalpel)', 'Rename (substitute)'],
      \ }

let g:which_key_map.s = {
      \ 'name' : '+search',
      \ '/' : [':History/',         'History'],
      \ ';' : [':Commands',         'Commands'],
      \ 'b' : [':Buffers',          'Open buffers'],
      \ 'c' : [':Commits',          'Commits'],
      \ 'C' : [':BCommits',         'Buffer commits'],
      \ 'd' : [':Files %:p:h',      'Current file directory'],
      \ 'D' : [':DRg',              'Current file directory text'],
      \ 'f' : [':Files',            'Files'],
      \ 'G' : [':GFiles?',          'Modified git files'],
      \ 'h' : [':History',          'File history'],
      \ 'H' : [':History:',         'Command history'],
      \ 'l' : [':BLines',           'Buffer lines'] ,
      \ 'L' : [':Lines',            'Lines'] ,
      \ 'm' : [':Marks',            'Marks'] ,
      \ 'M' : [':Maps',             'Normal maps'] ,
      \ 'p' : [':Helptags',         'Help tags'] ,
      \ 'P' : [':Tags',             'Project tags'],
      \ 's' : [':CocList snippets', 'Snippets'],
      \ 'S' : [':Colors',           'Color schemes'],
      \ 't' : [':Rg',               'Text Rg'],
      \ 'T' : [':BTags',            'Buffer tags'],
      \ 'v' : [':Vista finder coc', 'Vista finder coc'],
      \ 'w' : [':Windows',          'Search windows'],
      \ 'y' : [':Filetypes',        'File types'],
      \ }

let g:which_key_localmap.t = {
      \ 'name' : '+toggle',
      \ 'i' : [':IndentBlanklineToggle',              'Show indent'],
      \ 't' : ['TagbarToggle',                   'Tagbar'],
      \ 'f' : [':FloatermToggle',                'Floaterm'],
      \ 'e' : [':LuaTreeToggle',                 'Explorer' ],
      \ 'v' : [':Vista!!',                       'Vista bar' ],
      \ 'c' : [':ColorizerToggle',               'Colorizer'],
      \ 'n' : [':set number!',                   'Line numbers'],
      \ 'r' : [':set number! norelativenumber!', 'Hybrid line numbers'],
      \ 's' : [':let @/ = ""',                   'Remove search highlight'],
      \ 'm' : [':MundoToggle',                   'Mundo (local history)'],
      \ }


let g:which_key_map.t = {
      \ 'name' : '+terminal',
      \ ';' : [':FloatermNew',            'New Floaterm'],
      \ 'c' : [':FloatermNew! cd %:p:h',  'Floaterm current directory'],
      \ 'd' : [':FloatermNew lazydocker', 'Docker'],
      \ 'f' : [':FloatermNew fzf',        'Fzf'],
      \ 'g' : [':FloatermNew lazygit',    'Git'],
      \ 'h' : [':FloatermPrev',           'Floaterm prev'],
      \ 'k' : [':FloatermKill',           'Floaterm kill'],
      \ 'l' : [':FloatermNext',           'Floaterm next'],
      \ 'n' : [':FloatermNew node',       'Node'],
      \ 'p' : [':FloatermNew python',     'Python'],
      \ 'v' : [':FloatermNew vifm',       'Vifm'],
      \ 't' : [':FloatermToggle',         'Toggle'],
      \ 'y' : [':FloatermNew ytop',       'Ytop'],
      \ 's' : [':FloatermNew ncdu',       'Ncdu'],
      \ }

let g:which_key_map.v = {
      \ 'name' : '+vifm',
      \ 'n' : [':Vifm .',     'Normal'],
      \ 'v' : [':VsplitVifm', 'Vsplit'],
      \ 's' : [':SplitVifm',  'Split'],
      \ 'd' : [':DiffVifm',   'Diff'],
      \ 't' : [':TabVifm',    'Tab'],
      \ }

let g:which_key_map.w = {
      \ 'name' : '+window',
      \ 'm' : [':MaximizerToggle',     'Toggle Maximizer'],
      \ }
call which_key#register('<Space>', "g:which_key_map")
call which_key#register('-', "g:which_key_localmap")
