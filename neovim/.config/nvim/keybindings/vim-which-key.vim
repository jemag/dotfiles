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
let g:which_key_map['e'] = [ ':NvimTreeToggle',          'Explorer' ]
let g:which_key_map['E'] = [ ':NvimTreeFindFile',          'Show file' ]
let g:which_key_map['S'] = [ ':SSave',                  'Save session' ]
let g:which_key_map['L'] = [ ':SLoad',                  'Load session' ]
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
      \ 'n' : ['BufferNext',                     'Next-buffer']     ,
      \ 'p' : ['BufferPrevious',                 'Previous-buffer'] ,
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

let g:which_key_map.f = {
      \ 'name' : '+format' ,
      \ 'f' : ['<Plug>(coc-format-selected)', 'Format selected'],
      \ 'F' :           'Format',
      \ 'e' : ['<Plug>(EasyAlign)',           'Easy align'],
      \ }

let g:which_key_localmap.g = {
      \ 'name' : '+git',
      \ 'a' : [':Git add .',                   'Add all'],
      \ 'A' : [':Git add %',                   'Add current'],
      \ 'b' : [':Git blame',                   'Blame'],
      \ 'B' : [':GBrowse',                     'Browse'],
      \ 'c' : [':Git commit',                  'Commit'],
      \ 'd' : [':DiffviewOpen',                'Diff view'],
      \ 'D' : [':Gdiffsplit',                  'Diff split'],
      \ 's' : [':Git',                         'Status'],
      \ 'i' : ['<Plug>(GitGutterPreviewHunk)', 'Chunk info'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)',    'Next chunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)',    'Prev chunk'],
      \ 'l' : [':Git log',                     'Log'],
      \ 'p' : [':Git push',                    'Push'],
      \ 'P' : [':Git pull',                    'Pull'],
      \ 'r' : [':GRemove',                     'Remove'],
      \ 'S' : ['<Plug>(GitGutterStageHunk)',   'Stage chunk'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)',    'Undo chunk'],
      \ 'v' : [':GV',                          'View commits'],
      \ 'V' : [':GV!',                         'View buffer commits'],
      \ }

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
      \ 'a' : [':BookmarkShowAll',                      'Show all'],
      \ 'c' : [':BookmarkClear',                        'Clear'],
      \ 'i' : [':BookmarkAnnotate',                     'Annotate'],
      \ 'j' : [':BookmarkMoveDown',                     'Move down'],
      \ 'k' : [':BookmarkMoveUp',                       'Move up'],
      \ 'm' : [':BookmarkToggle',                       'Toggle'],
      \ 'n' : [':BookmarkNext',                         'Next bookmark'],
      \ 'p' : [':BookmarkPrev',                         'Prev bookmark'],
      \ 's' : [':Telescope vim_bookmarks all',          'All annotated bookmarks'],
      \ 'S' : [':Telescope vim_bookmarks current_file', 'Current file annotated bookmarks'],
      \ 'x' : [':BookmarkClearAll',                     'Clear all'],
      \ }

let g:which_key_map.r = {
      \ 'name' : '+refactor',
      \ 'r' : ['<Plug>(Scalpel)', 'Rename (substitute)'],
      \ }

let g:which_key_map.s = {
      \ 'name' : '+search',
      \ '/' : [':Telescope current_buffer_fuzzy_find',                                                 'Find in buffer'],
      \ ':' : [':Telescope commands',                                                                  'Commands'],
      \ 'b' : [':Telescope buffers',                                                                   'Open buffers'],
      \ 'B' : [':Telescope builtin',                                                                   'Telescope builtin'],
      \ 'c' : [':Telescope git_commits',                                                               'Commits'],
      \ 'C' : [':Telescope git_bcommits',                                                              'Buffer commits'],
      \ 'd' : [':Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs cwd=%:p:h', 'Current file directory'],
      \ 'D' : [':Telescope live_grep cwd=%:p:h',                                                       'Current file directory text'],
      \ 'f' : [':Telescope find_files hidden=true',                                                    'Files'],
      \ 'F' : [':Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs',           'Files'],
      \ 'G' : [':Telescope git_status',                                                                'Modified git files'],
      \ 'h' : [':Telescope oldfiles',                                                                  'File history'],
      \ 'H' : [':Telescope command_history',                                                           'Command history'],
      \ 'k' : [':Telescope keymaps',                                                                   'Keymaps'] ,
      \ 'l' : [':Telescope loclist',                                                                   'Location list'] ,
      \ 'm' : [':Telescope marks',                                                                     'Marks'] ,
      \ 'M' : [':Telescope media_files',                                                               'Media files'] ,
      \ 'p' : [':Telescope help_tags',                                                                 'Help tags'] ,
      \ 'P' : [':Telescope tags',                                                                      'Directory tags'],
      \ 'q' : [':Telescope quickfix',                                                                  'Quickfix'],
      \ 's' : [':Telescope lsp_document_symbols',                                                      'Color schemes'],
      \ 'S' : [':Telescope colorscheme',                                                               'Color schemes'],
      \ 't' : [':Telescope live_grep',                                                                 'Text Rg'],
      \ 'T' : [':TodoTelescope',                                                                       'TODOs'],
      \ 'v' : [':Vista finder',                                                                        'Vista finder'],
      \ 'V' : [':Telescope vim_options',                                                               'Vim options'],
      \ 'w' : [':Windows',                                                                             'Search windows'],
      \ 'y' : [':Filetypes',                                                                           'File types'],
      \ }

let g:which_key_localmap.t = {
      \ 'name': '+toggle',
      \ 'a':    [':TZAtaraxis',                    'TZAtaris'],
      \ 'c':    [':ColorizerToggle',               'Colorizer'],
      \ 'd':    [':LspTroubleToggle',              'Lsp Trouble (diagnostics)'],
      \ 'e':    [':NvimTreeToggle',                'Explorer' ],
      \ 'f':    [':FloatermToggle',                'Floaterm'],
      \ 'i':    'Toggle indent blank lines',
      \ 'L':    [':Limelight!!',                   'Limelight'],
      \ 'm':    [':MundoToggle',                   'Mundo (local history)'],
      \ 'M':    [':TZMinimalist',                  'TZMinimalist'],
      \ 'n':    [':set number!',                   'Line numbers'],
      \ 'r':    [':set number! norelativenumber!', 'Hybrid line numbers'],
      \ 's':    [':SymbolsOutline',                'Symbols Outline'],
      \ 't':    ['TagbarToggle',                   'Tagbar'],
      \ 'v':    [':Vista!!',                       'Vista bar' ],
      \ 'z':    [':ZenMode',                       'Zen mode' ],
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
      \ 't' : [':tabclose',     'Close tab'],
      \ }
call which_key#register('<Space>', "g:which_key_map")
call which_key#register('-', "g:which_key_localmap")
