vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "'", "printf('`%c zz',getchar())", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "R", '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<esc>", "<cmd>noh<return><esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "jk", "<esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "H", "<cmd>BufferPrevious<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", "<cmd>BufferNext<cr>", { noremap = true, silent = true })

--[[ vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true }) ]]

vim.api.nvim_set_keymap("n", "<Right>", "<cmd>cnext<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", "<cmd>cprev<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Up>", "<cmd>copen<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "<cmd>cclose<cr>", { noremap = true, silent = true })

-- do not put replaced text in register
vim.api.nvim_set_keymap("v", "p", '"_dP', { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<C-u>", "<C-g>u<C-u>", { noremap = true, silent = true })
-- Set undo breakpoints in insert mode so that it doesn't cancel all the text written
vim.api.nvim_set_keymap("i", ",", ",<C-g>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", ".", ".<C-g>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "!", "!<C-g>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "?", "?<C-g>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<space>/",
  "<cmd>noh | lua require'hop'.hint_patterns({}, vim.fn['getreg']('/'))<cr>",
  { noremap = true }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-f>",
  "<cr><cmd>lua require'hop'.hint_patterns({}, vim.fn['getreg']('/'))<cr>",
  { noremap = true }
)
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gj", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "k", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "gj", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "gk", "k", { noremap = true, silent = true })

vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<c-g>", "1<c-g>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<M-j>", "<cmd>resize -2<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-k>", "<cmd>resize +2<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-h>", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-l>", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  "n",
  "<leader>o",
  '<cmd>call append(line("."),   repeat([""], v:count1))<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>O",
  '<cmd>call append(line(".")-1, repeat([""], v:count1))<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<C-n>",
  "<cmd>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>",
  { noremap = true, silent = true }
)

-- Count relative line number movements toward jump list if we move by more than 5 lines
vim.api.nvim_set_keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "k"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "j"', { noremap = true, expr = true })

vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<c-w><c-m>", "<cmd>WinShift<cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("t", "<c-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-l>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-o>", [[<C-\><C-n><esc><cr>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap("x", "<leader>y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Y", '"+yg_', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>yy", '"+yy', { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>p", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>P", '"+P', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>p", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>P", '"+P', { noremap = true, silent = true })
require("which-key").setup({
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
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k", "y" },
    o = { "j", "k", "y" },
    v = { "j", "k", "y" },
  },
})

local leader_mappings = {
  ["."] = { "<cmd>e $MYVIMRC<cr>", "Open init" },
  [";"] = { "<cmd>Commands<cr>", "Commands" },
  [","] = { "<cmd>Startify<cr>", "Start screen" },
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["E"] = { "<cmd>NvimTreeFindFile<cr>", "Show file" },
  ["i"] = { "<cmd>HopPatternAC<cr>", "HopPattern forward" },
  ["I"] = { "<cmd>HopPatternBC<cr>", "HopPattern backward" },
  ["S"] = { "<cmd>SSave<cr>", "Save session" },
  ["L"] = { "<cmd>SLoad<cr>", "Load session" },
  ["1"] = { "<cmd>BufferGoto 1<cr>", "Buf 1" },
  ["2"] = { "<cmd>BufferGoto 2<cr>", "Buf 2" },
  ["3"] = { "<cmd>BufferGoto 3<cr>", "Buf 3" },
  ["4"] = { "<cmd>BufferGoto 4<cr>", "Buf 4" },
  ["5"] = { "<cmd>BufferGoto 5<cr>", "Buf 5" },
  ["6"] = { "<cmd>BufferGoto 6<cr>", "Buf 6" },
  ["7"] = { "<cmd>BufferGoto 7<cr>", "Buf 7" },
  ["8"] = { "<cmd>BufferGoto 8<cr>", "Buf 8" },
  ["9"] = { "<cmd>BufferGoto 9<cr>", "Buf 9" },
  ["0"] = { "<cmd>BufferGoto 10<cr>", "Buf 10" },
  b = {
    name = "+buffer",
    d = { "<cmd>BufferClose<cr>", "Delete-buffer" },
    D = { "<cmd>BufferCloseAllButCurrent<cr>", "Delete all other buffers" },
    e = { "<cmd>blast<cr>", "Last-buffer" },
    f = { "<cmd>bfirst<cr>", "First-buffer" },
    h = { "<cmd>BufferMovePrevious<cr>", "move prev" },
    l = { "<cmd>BufferMoveNext<cr>", "move next" },
    r = { "<cmd>BufferCloseBuffersRight<cr>", "delete buffers to the right" },
    S = { "<cmd>Startify<cr>", "Startify" },
    n = { "<cmd>BufferNext<cr>", "Next-buffer" },
    p = { "<cmd>BufferPrevious<cr>", "Previous-buffer" },
    s = { "<cmd>BufferPick<cr>", "Magic buffer select" },
    ["?"] = { "Buffers", "Fzf-buffer" },
  },
  d = {
    name = "+debug",
    b = "Breakpoint",
    B = "Conditional breakpoint",
    e = { "<cmd>lua require('dapui').eval()<cr>", "Eval expression" },
    l = "Repl run last",
    p = "Breakpoint with log",
    r = "Repl open",
    u = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle dap ui" },
  },
  f = {
    name = "+format",
    b = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
    e = { "<Plug>(EasyAlign)", "Easy align", mode = "v" },
    r = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Range formatting" },
  },
  l = {
    name = "+language",
    c = "Cursor diagnostics",
    d = "Definition",
    D = "Declaration",
    h = "Hover",
    i = "Implementation",
    l = "Show line diagnostics",
    n = "Next diagnostic",
    N = "Previous diagnostic",
    r = "References",
    R = "Rename",
    s = "Signature help",
    t = "Type definition",
    w = "Document symbol",
    W = "Workspace symbol",
  },
  m = {
    name = "+bookmarks",
    a = { "<cmd>BookmarkShowAll<cr>", "Show all" },
    c = { "<cmd>BookmarkClear<cr>", "Clear" },
    i = { "<cmd>BookmarkAnnotate<cr>", "Annotate" },
    j = { "<cmd>BookmarkMoveDown<cr>", "Move down" },
    k = { "<cmd>BookmarkMoveUp<cr>", "Move up" },
    m = { "<cmd>BookmarkToggle<cr>", "Toggle" },
    n = { "<cmd>BookmarkNext<cr>", "Next bookmark" },
    p = { "<cmd>BookmarkPrev<cr>", "Prev bookmark" },
    s = { "<cmd>Telescope vim_bookmarks all<cr>", "All annotated bookmarks" },
    S = { "<cmd>Telescope vim_bookmarks current_file<cr>", "Current file annotated bookmarks" },
    x = { "<cmd>BookmarkClearAll<cr>", "Clear all" },
  },
  r = {
    name = "+refactor",
    r = { "<Plug>(Scalpel)", "Rename (substitute)" },
  },
  s = {
    name = "+search",
    ["/"] = {
      "<cmd>Telescope current_buffer_fuzzy_find<cr>",
      "Find in buffer",
    },
    [":"] = {
      "<cmd>Telescope commands<cr>",
      "Commands",
    },
    ["b"] = {
      "<cmd>Telescope buffers<cr>",
      "Open buffers",
    },
    ["B"] = {
      "<cmd>Telescope builtin<cr>",
      "Telescope builtin",
    },
    ["c"] = {
      "<cmd>Telescope git_commits<cr>",
      "Commits",
    },
    ["C"] = {
      "<cmd>Telescope git_bcommits<cr>",
      "Buffer commits",
    },
    ["d"] = {
      "<cmd>Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs cwd=%:p:h<cr>",
      "Current file directory",
    },
    ["D"] = {
      "<cmd>Telescope live_grep cwd=%:p:h<cr>",
      "Current file directory text",
    },
    ["f"] = { "<cmd>Telescope find_files hidden=true<cr>", "Files" },
    ["F"] = { "<cmd>Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs<cr>", "Files" },
    ["G"] = {
      "<cmd>Telescope git_status<cr>",
      "Modified git files",
    },
    ["h"] = {
      "<cmd>Telescope command_history<cr>",
      "Command history",
    },
    ["H"] = {
      "<cmd>Telescope oldfiles<cr>",
      "File history",
    },
    ["k"] = {
      "<cmd>Telescope keymaps<cr>",
      "Keymaps",
    },
    ["l"] = {
      "<cmd>Telescope loclist<cr>",
      "Location list",
    },
    ["m"] = { "<cmd>Telescope marks<cr>", "Marks" },
    ["M"] = {
      "<cmd>Telescope media_files<cr>",
      "Media files",
    },
    ["p"] = {
      "<cmd>Telescope help_tags<cr>",
      "Help tags",
    },
    ["P"] = {
      "<cmd>Telescope tags<cr>",
      "Directory tags",
    },
    ["q"] = {
      "<cmd>Telescope quickfix<cr>",
      "Quickfix",
    },
    ["s"] = {
      "<cmd>Telescope lsp_document_symbols<cr>",
      "LSP symbols",
    },
    ["S"] = {
      "<cmd>Telescope colorscheme<cr>",
      "Color schemes",
    },
    ["t"] = {
      "<cmd>Telescope live_grep<cr>",
      "Text Rg",
    },
    ["T"] = { "<cmd>TodoTelescope<cr>", "TODOs" },
    ["v"] = {
      "<cmd>Vista finder<cr>",
      "Vista finder",
    },
    ["V"] = {
      "<cmd>Telescope vim_options<cr>",
      "Vim options",
    },
    ["w"] = {
      "<cmd>Windows<cr>",
      "Search windows",
    },
    ["y"] = {
      "<cmd>Filetypes<cr>",
      "File types",
    },
  },
  t = {
    name = "+terminal",
    [";"] = { "<cmd>FloatermNew<cr>", "New Floaterm" },
    c = { "<cmd>FloatermNew! cd %:p:h<cr>", "Floaterm current directory" },
    d = { "<cmd>FloatermNew lazydocker<cr>", "Docker" },
    f = { "<cmd>FloatermNew fzf<cr>", "Fzf" },
    g = { "<cmd>FloatermNew lazygit<cr>", "Git" },
    h = { "<cmd>FloatermPrev<cr>", "Floaterm prev" },
    k = { "<cmd>FloatermKill<cr>", "Floaterm kill" },
    l = { "<cmd>FloatermNext<cr>", "Floaterm next" },
    n = { "<cmd>FloatermNew node<cr>", "Node" },
    p = { "<cmd>FloatermNew python<cr>", "Python" },
    v = { "<cmd>FloatermNew vifm<cr>", "Vifm" },
    t = { "<cmd>FloatermToggle<cr>", "Toggle" },
    y = { "<cmd>FloatermNew ytop<cr>", "Ytop" },
    s = { "<cmd>FloatermNew ncdu<cr>", "Ncdu" },
  },
  v = {
    name = "+vifm",
    n = { "<cmd>Vifm .<cr>", "Normal" },
    v = { "<cmd>VsplitVifm<cr>", "Vsplit" },
    s = { "<cmd>SplitVifm<cr>", "Split" },
    d = { "<cmd>DiffVifm<cr>", "Diff" },
    t = { "<cmd>TabVifm<cr>", "Tab" },
  },
  w = {
    name = "+window",
    m = { "<cmd>MaximizerToggle<cr>", "Toggle Maximizer" },
    t = { "<cmd>tabclose<cr>", "Close tab" },
  },
}

local local_leader_mappings = {
  g = {
    name = "+git",
    a = { "<cmd>Git add .<cr>", "Add all" },
    A = { "<cmd>Git add %<cr>", "Add current" },
    b = { "<cmd>Git blame<cr>", "Blame" },
    B = { "<cmd>GBrowse<cr>", "Browse" },
    c = { "<cmd>Git commit<cr>", "Commit" },
    d = { "<cmd>DiffviewOpen<cr>", "Diff view" },
    D = { "<cmd>Gdiffsplit<cr>", "Diff split" },
    l = { "<cmd>Git log<cr>", "Log" },
    h = { "<cmd>DiffviewFileHistory<cr>", "File history" },
    p = { "<cmd>Git push<cr>", "Push" },
    P = { "<cmd>Git pull<cr>", "Pull" },
    r = { "<cmd>GRemove<cr>", "Remove" },
    s = { "<cmd>Git<cr>", "Status" },
    v = { "<cmd>GV<cr>", "View commits" },
    V = { "<cmd>GV!<cr>", "View buffer commits" },
  },
  t = {
    name = "+toggle",
    b = { "<cmd>Telescope file_browser hidden=true<cr>", "Telescope browser" },
    B = { "<cmd>Telescope file_browser hidden=true cwd=%:p:h<cr>", "Telescope browser current dir" },
    c = { "<cmd>ColorizerToggle<cr>", "Colorizer" },
    d = { "<cmd>LspTroubleToggle<cr>", "Lsp Trouble (diagnostics)" },
    D = { "<cmd>call v:lua.toggle_diagnostics()<cr>", "Toggle LSP diagnostics signs" },
    e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    f = { "<cmd>FloatermToggle<cr>", "Floaterm" },
    i = "Toggle indent blank lines",
    L = { "<cmd>Limelight!!<cr>", "Limelight" },
    m = { "<cmd>MundoToggle<cr>", "Mundo (local history)" },
    M = { "<cmd>TZMinimalist<cr>", "TZMinimalist" },
    n = { "<cmd>Neogit<cr>", "Neogit" },
    N = { "<cmd>set number!<cr>", "Line numbers" },
    r = { "<cmd>set number! norelativenumber!<cr>", "Hybrid line numbers" },
    s = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
    S = { '<cmd>lua require("spectre").open()<CR>', "Open Spectre" },
    t = { "TagbarToggle", "Tagbar" },
    u = { "<cmd>UndotreeToggle<cr>", "Undotree" },
    v = { "<cmd>Vista!!<cr>", "Vista bar" },
    z = { "<cmd>ZenMode<cr>", "Zen mode" },
  },
}
require("which-key").register(leader_mappings, {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
})
require("which-key").register(leader_mappings, {
  mode = "x", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
})
require("which-key").register(local_leader_mappings, {
  mode = "n", -- NORMAL mode
  prefix = "<localleader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
})
