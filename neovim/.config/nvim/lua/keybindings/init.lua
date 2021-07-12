require("which-key").setup{
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k", "y"},
    o = { "j", "k", "y"},
    v = { "j", "k", "y"},
  },
}

local leader_mappings = {
  ['.'] = { '<cmd>e $MYVIMRC<cr>',             'Open init' },
  [';'] = { '<cmd>Commands<cr>',               'Commands' },
  [','] = { 'Startify',                'Start screen' },
  ['e'] = { '<cmd>NvimTreeToggle<cr>',          'Explorer' },
  ['E'] = { '<cmd>NvimTreeFindFile<cr>',          'Show file' },
  ['S'] = { '<cmd>SSave<cr>',                  'Save session' },
  ['L'] = { '<cmd>SLoad<cr>',                  'Load session' },
  ['1'] = { '<cmd>BufferGoto 1<cr>',  'Buf 1' },
  ['2'] = { '<cmd>BufferGoto 2<cr>',  'Buf 2' },
  ['3'] = { '<cmd>BufferGoto 3<cr>',  'Buf 3' },
  ['4'] = { '<cmd>BufferGoto 4<cr>',  'Buf 4' },
  ['5'] = { '<cmd>BufferGoto 5<cr>',  'Buf 5' },
  ['6'] = { '<cmd>BufferGoto 6<cr>',  'Buf 6' },
  ['7'] = { '<cmd>BufferGoto 7<cr>',  'Buf 7' },
  ['8'] = { '<cmd>BufferGoto 8<cr>',  'Buf 8' },
  ['9'] = { '<cmd>BufferGoto 9<cr>',  'Buf 9' },
  ['0'] = { '<cmd>BufferGoto 10<cr>', 'Buf 10' },
  b = {
    name = '+buffer',
    d = {'<cmd>BufferClose<cr>',              'Delete-buffer'}   ,
    D = {'<cmd>BufferCloseAllButCurrent<cr>', 'Delete all other buffers'}   ,
    e = {'blast',                             'Last-buffer'}     ,
    f = {'bfirst',                            'First-buffer'}    ,
    h = {'<cmd>BufferMovePrevious<cr>',       'move prev'},
    l = {'<cmd>BufferMoveNext<cr>',           'move next'},
    r = {'<cmd>BufferCloseBuffersRight<cr>',  'delete buffers to the right'},
    S = {'Startify',                          'Startify'}     ,
    n = {'BufferNext',                        'Next-buffer'}     ,
    p = {'BufferPrevious',                    'Previous-buffer'} ,
    s = {'<cmd>BufferPick<cr>',               'Magic buffer select'} ,
    ['?'] = {'Buffers',                       'Fzf-buffer'}      ,
  },
  d = {
    name = '+debug' ,
    b =      'Breakpoint',
    B =      'Conditional breakpoint',
    l =      'Repl run last',
    p =      'Breakpoint with log',
    r =      'Repl open',
  },
  f = {
    name = '+format',
    f = {'<Plug>(coc-format-selected)', 'Format selected'},
    F =           'Format',
    e = {'<Plug>(EasyAlign)',           'Easy align', mode = 'v'},
  },
  l = {
    name = '+language' ,
    d =      'Definition',
    D =      'Declaration',
    h =      'Hover',
    i =      'Implementation',
    l =      'Show line diagnostics',
    n =      'Next diagnostic',
    N =      'Previous diagnostic',
    r =      'References',
    R =      'Rename',
    s =      'Signature help',
    t =      'Type definition',
    w =      'Document symbol',
    W =      'Workspace symbol',
  },
  m = {
    name = '+bookmarks',
    a = {'<cmd>BookmarkShowAll<cr>',                      'Show all'},
    c = {'<cmd>BookmarkClear<cr>',                        'Clear'},
    i = {'<cmd>BookmarkAnnotate<cr>',                     'Annotate'},
    j = {'<cmd>BookmarkMoveDown<cr>',                     'Move down'},
    k = {'<cmd>BookmarkMoveUp<cr>',                       'Move up'},
    m = {'<cmd>BookmarkToggle<cr>',                       'Toggle'},
    n = {'<cmd>BookmarkNext<cr>',                         'Next bookmark'},
    p = {'<cmd>BookmarkPrev<cr>',                         'Prev bookmark'},
    s = {'<cmd>Telescope vim_bookmarks all<cr>',          'All annotated bookmarks'},
    S = {'<cmd>Telescope vim_bookmarks current_file<cr>', 'Current file annotated bookmarks'},
    x = {'<cmd>BookmarkClearAll<cr>',                     'Clear all'},
  },
  r = {
    name = '+refactor',
    r = {'<Plug>(Scalpel)', 'Rename (substitute)'},
  },
  s = {
    name = '+search',
    ['/'] = {'<cmd>Telescope current_buffer_fuzzy_find<cr>',                                                 'Find in buffer'},
    [':'] = {'<cmd>Telescope commands<cr>',                                                                  'Commands'},
    ['b'] = {'<cmd>Telescope buffers<cr>',                                                                   'Open buffers'},
    ['B'] = {'<cmd>Telescope builtin<cr>',                                                                   'Telescope builtin'},
    ['c'] = {'<cmd>Telescope git_commits<cr>',                                                               'Commits'},
    ['C'] = {'<cmd>Telescope git_bcommits<cr>',                                                              'Buffer commits'},
    ['d'] = {'<cmd>Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs cwd=%:p:h<cr>', 'Current file directory'},
    ['D'] = {'<cmd>Telescope live_grep cwd=%:p:h<cr>',                                                       'Current file directory text'},
    ['f'] = {'<cmd>Telescope find_files hidden=true<cr>',                                                    'Files'},
    ['F'] = {'<cmd>Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs<cr>',           'Files'},
    ['G'] = {'<cmd>Telescope git_status<cr>',                                                                'Modified git files'},
    ['h'] = {'<cmd>Telescope oldfiles<cr>',                                                                  'File history'},
    ['H'] = {'<cmd>Telescope command_history<cr>',                                                           'Command history'},
    ['k'] = {'<cmd>Telescope keymaps<cr>',                                                                   'Keymaps'} ,
    ['l'] = {'<cmd>Telescope loclist<cr>',                                                                   'Location list'} ,
    ['m'] = {'<cmd>Telescope marks<cr>',                                                                     'Marks'} ,
    ['M'] = {'<cmd>Telescope media_files<cr>',                                                               'Media files'} ,
    ['p'] = {'<cmd>Telescope help_tags<cr>',                                                                 'Help tags'} ,
    ['P'] = {'<cmd>Telescope tags<cr>',                                                                      'Directory tags'},
    ['q'] = {'<cmd>Telescope quickfix<cr>',                                                                  'Quickfix'},
    ['s'] = {'<cmd>Telescope lsp_document_symbols<cr>',                                                      'LSP symbols'},
    ['S'] = {'<cmd>Telescope colorscheme<cr>',                                                               'Color schemes'},
    ['t'] = {'<cmd>Telescope live_grep<cr>',                                                                 'Text Rg'},
    ['T'] = {'<cmd>TodoTelescope<cr>',                                                                       'TODOs'},
    ['v'] = {'<cmd>Vista finder<cr>',                                                                        'Vista finder'},
    ['V'] = {'<cmd>Telescope vim_options<cr>',                                                               'Vim options'},
    ['w'] = {'<cmd>Windows<cr>',                                                                             'Search windows'},
    ['y'] = {'<cmd>Filetypes<cr>',                                                                           'File types'},
  },
  t = {
    name = '+terminal',
    [';'] = {'<cmd>FloatermNew<cr>',            'New Floaterm'},
    c = {'<cmd>FloatermNew! cd %:p:h<cr>',  'Floaterm current directory'},
    d = {'<cmd>FloatermNew lazydocker<cr>', 'Docker'},
    f = {'<cmd>FloatermNew fzf<cr>',        'Fzf'},
    g = {'<cmd>FloatermNew lazygit<cr>',    'Git'},
    h = {'<cmd>FloatermPrev<cr>',           'Floaterm prev'},
    k = {'<cmd>FloatermKill<cr>',           'Floaterm kill'},
    l = {'<cmd>FloatermNext<cr>',           'Floaterm next'},
    n = {'<cmd>FloatermNew node<cr>',       'Node'},
    p = {'<cmd>FloatermNew python<cr>',     'Python'},
    v = {'<cmd>FloatermNew vifm<cr>',       'Vifm'},
    t = {'<cmd>FloatermToggle<cr>',         'Toggle'},
    y = {'<cmd>FloatermNew ytop<cr>',       'Ytop'},
    s = {'<cmd>FloatermNew ncdu<cr>',       'Ncdu'},
  },
  v= {
    name = '+vifm',
    n = {'<cmd>Vifm .<cr>',     'Normal'},
    v = {'<cmd>VsplitVifm<cr>', 'Vsplit'},
    s = {'<cmd>SplitVifm<cr>',  'Split'},
    d = {'<cmd>DiffVifm<cr>',   'Diff'},
    t = {'<cmd>TabVifm<cr>',    'Tab'},
  },
  w = {
    name = '+window',
    m = {':MaximizerToggle',     'Toggle Maximizer'},
    t = {':tabclose',     'Close tab'},
  },
}

local local_leader_mappings = {
  g = {
    name = '+git',
    a = {'<cmd>Git add .<cr>',           'Add all'},
    A = {'<cmd>Git add %<cr>',           'Add current'},
    b = {'<cmd>Git blame<cr>',           'Blame'},
    B = {'<cmd>GBrowse<cr>',             'Browse'},
    c = {'<cmd>Git commit<cr>',          'Commit'},
    d = {'<cmd>DiffviewOpen<cr>',        'Diff view'},
    D = {'<cmd>Gdiffsplit<cr>',          'Diff split'},
    s = {'<cmd>Git<cr>',                 'Status'},
    i = {'<Plug>(GitGutterPreviewHunk)', 'Chunk info'},
    j = {'<Plug>(GitGutterNextHunk)',    'Next chunk'},
    k = {'<Plug>(GitGutterPrevHunk)',    'Prev chunk'},
    l = {'<cmd>Git log<cr>',             'Log'},
    p = {'<cmd>Git push<cr>',            'Push'},
    P = {'<cmd>Git pull<cr>',            'Pull'},
    r = {'<cmd>GRemove<cr>',             'Remove'},
    S = {'<Plug>(GitGutterStageHunk)',   'Stage chunk'},
    u = {'<Plug>(GitGutterUndoHunk)',    'Undo chunk'},
    v = {'<cmd>GV<cr>',                  'View commits'},
    V = {'<cmd>GV!<cr>',                 'View buffer commits'},
  },
  t = {
    name= '+toggle',
    b =    {'<cmd>Telescope file_browser hidden=true<cr>',           'Telescope browser'},
    B =    {'<cmd>Telescope file_browser hidden=true cwd=%:p:h<cr>', 'Telescope browser current dir'},
    c =    {'<cmd>ColorizerToggle<cr>',                              'Colorizer'},
    d =    {'<cmd>LspTroubleToggle<cr>',                             'Lsp Trouble (diagnostics)'},
    D =    {'<cmd>call v:lua.toggle_diagnostics()<cr>',              'Toggle LSP diagnostics signs'},
    e =    {'<cmd>NvimTreeToggle<cr>',                               'Explorer' },
    f =    {'<cmd>FloatermToggle<cr>',                               'Floaterm'},
    i =    'Toggle indent blank lines',
    L =    {'<cmd>Limelight!!<cr>',                                  'Limelight'},
    m =    {'<cmd>MundoToggle<cr>',                                  'Mundo (local history)'},
    M =    {'<cmd>TZMinimalist<cr>',                                 'TZMinimalist'},
    n =    {'<cmd>set number!<cr>',                                  'Line numbers'},
    r =    {'<cmd>set number! norelativenumber!<cr>',                'Hybrid line numbers'},
    s =    {'<cmd>SymbolsOutline<cr>',                               'Symbols Outline'},
    t =    {'TagbarToggle',                                          'Tagbar'},
    v =    {'<cmd>Vista!!<cr>',                                      'Vista bar' },
    z =    {'<cmd>ZenMode<cr>',                                      'Zen mode' },
  }

}
require("which-key").register(leader_mappings, {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false -- use `nowait` when creating keymaps
})
require("which-key").register(leader_mappings, {
  mode = "v", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false -- use `nowait` when creating keymaps
})
require("which-key").register(local_leader_mappings, {
  mode = "n", -- NORMAL mode
  prefix = "<localleader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false -- use `nowait` when creating keymaps
})
