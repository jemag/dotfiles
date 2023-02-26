local buffer_diagnostic_state ={}
local toggle_diagnostic = function()
local buf_id = vim.api.nvim_get_current_buf()
  local buf_state = buffer_diagnostic_state[buf_id]
  if buf_state == nil then buf_state = true end

  if buf_state then
    vim.diagnostic.disable(buf_id)
  else
    vim.diagnostic.enable(buf_id)
  end

  local new_buf_state = not buf_state
  buffer_diagnostic_state[buf_id] = new_buf_state

  return new_buf_state and '  diagnostic' or 'nodiagnostic'
end
-- More convenient horizontal scrolling
vim.api.nvim_set_keymap("n", "zh", "<cmd>call HorizontalScrollMode('h')<cr>", { noremap = true, silent = true, desc = "Left scroll" })
vim.api.nvim_set_keymap("n", "zl", "<cmd>call HorizontalScrollMode('l')<cr>", { noremap = true, silent = true, desc = "Right scroll" })
vim.api.nvim_set_keymap(
  "n",
  "zH",
  "<cmd>call HorizontalScrollMode('H')<cr>",
  { noremap = true, silent = true, desc = "Left half-screen scroll" }
)
vim.api.nvim_set_keymap(
  "n",
  "zL",
  "<cmd>call HorizontalScrollMode('L')<cr>",
  { noremap = true, silent = true, desc = "Right half-screen scroll" }
)
-- Testing centering cursor
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll half down with cursor centered" })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll half up with cursor centered" })
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true, desc = "Scroll down with cursor centered" })
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true, desc = "Scroll up with cursor centered" })
vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true, desc = "Next match centered" })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true, desc = "Previous match centered" })

vim.api.nvim_set_keymap("n", "<C-s>", "<C-a>", { noremap = true, silent = true, desc = "Increment" })
vim.api.nvim_set_keymap("n", "'", "`", { noremap = true, silent = true, desc = "Exact position mark" })
vim.api.nvim_set_keymap("n", "R", '"_d', { noremap = true, silent = true, desc = "Delete without register" })
vim.api.nvim_set_keymap("n", "<esc>", "<cmd>noh<cr><esc>", { noremap = true, silent = true, desc = "Remove highlight or escape" })
vim.api.nvim_set_keymap("i", "jk", "<esc>", { noremap = true, silent = true, desc = "Escape" })

vim.keymap.set("n", "<c-i>", "<c-i>")

vim.api.nvim_set_keymap("n", "<Right>", "<cmd>cnext<cr>", { noremap = true, silent = true, desc = "Next quickfix item" })
vim.api.nvim_set_keymap("n", "<Left>", "<cmd>cprev<cr>", { noremap = true, silent = true, desc = "Prev quickfix item" })
vim.api.nvim_set_keymap("n", "<Up>", "<cmd>copen<cr>", { noremap = true, silent = true, desc = "Open quickfix" })
vim.api.nvim_set_keymap("n", "<Down>", "<cmd>cclose<cr>", { noremap = true, silent = true, desc = "Close quickfix" })

vim.api.nvim_set_keymap("i", "<C-u>", "<C-g>u<C-u>", { noremap = true, silent = true, desc = "Delete before cursor" })
vim.keymap.set({"n", "x"}, "j", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true, desc = "Visual j" })
vim.keymap.set({"n", "x"}, "k", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true, desc = "Visual k" })
vim.keymap.set({"n", "x"}, "gj", "j", { noremap = true, silent = true, desc = "Normal j" })
vim.keymap.set({"n", "x"}, "gk", "k", { noremap = true, silent = true, desc = "Normal k" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Keep cursor in the same position while joining lines" })
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Shift selection down" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Shift selection up" })

vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true, silent = true, desc = "Indent and keep selection" })
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true, silent = true, desc = "Indent and keep selection" })

vim.api.nvim_set_keymap("n", "<c-g>", "1<c-g>", { noremap = true, silent = true, desc = "Full path to current buffer" })

-- refactoring keybinds
vim.keymap.set("n", "<leader>rc", "<cmd>let @/='\\<'.expand('<cword>').'\\>'<cr>cgn", { desc = "Cgn current word" })
vim.keymap.set("x", "<leader>rc", '"sy:let @/=@s<CR>cgn', { desc = "Cgn current word" })
vim.keymap.set("n", "<leader>rs", ":%s/<c-r><c-w>//<Left>", { desc = "Replace word in file" })
vim.keymap.set("x", "<leader>rs", '"sy:%s/<C-r>s//<Left>', { desc = "Replace word in file" })

--  Reselect latest changed, put, or yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = "Visually select changed text" })
-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
vim.keymap.set("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
vim.keymap.set("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])
-- NOTE: could potentially use 'go' and 'gO' as well if we wanted to keep letter 'o' with leader key for more keybinds
vim.api.nvim_set_keymap(
  "n",
  "<leader>o",
  '<cmd>call append(line("."),   repeat([""], v:count1))<CR>',
  { noremap = true, silent = true, desc = "Append line underneath" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>O",
  '<cmd>call append(line(".")-1, repeat([""], v:count1))<CR>',
  { noremap = true, silent = true, desc = "Append line above" }
)

vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true, desc = "Yank till end of line" })

vim.api.nvim_set_keymap("i", "<c-w>", "<c-s-w>", { noremap = true })

vim.api.nvim_set_keymap("c", "<esc>", "<c-c>", { noremap = true, desc = "Esc as ctrl-c in command mode" })

vim.api.nvim_set_keymap("n", "<c-w>z", "<c-w>_<c-w>|", { noremap = true, desc = "Zoom current window" })
vim.api.nvim_set_keymap("t", "<c-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true, desc = "Left pane" })
vim.api.nvim_set_keymap("t", "<c-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true, desc = "Right pane" })
vim.api.nvim_set_keymap("t", "<c-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true, desc = "Up pane" })
vim.api.nvim_set_keymap("t", "<c-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true, desc = "Down pane" })
vim.api.nvim_set_keymap("t", "<c-o>", [[<C-\><C-n><esc><cr>]], { noremap = true, silent = true, desc = "Normal mode" })

-- NOTE: could use gy, gY, gs, gS, gp gP instead if we want to use y, s, and p with leader
vim.api.nvim_set_keymap("x", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank +reg" })
vim.api.nvim_set_keymap("n", "<leader>Y", '"+yg_', { noremap = true, silent = true, desc = "Yank end of line +reg" })
vim.api.nvim_set_keymap("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank +reg" })
vim.api.nvim_set_keymap("n", "<leader>yy", '"+yy', { noremap = true, silent = true, desc = "Yank whole line +reg" })

vim.api.nvim_set_keymap("n", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste after +reg" })
vim.api.nvim_set_keymap("n", "<leader>P", '"+P', { noremap = true, silent = true, desc = "Paste before +reg" })
vim.api.nvim_set_keymap("x", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste after +reg" })
vim.api.nvim_set_keymap("x", "<leader>P", '"+P', { noremap = true, silent = true, desc = "Paste before +reg" })

vim.keymap.set({ "n", "x" }, "<leader>.", "<cmd>e $MYVIMRC<cr>", { desc = "Open init" })
vim.keymap.set({ "n", "x" }, "<leader>nw", "<cmd>e ~/working-memory.md<cr>", { desc = "Working memory" })
vim.keymap.set("n", "<leader>fb", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format" })
vim.keymap.set("n", "<leader>wt", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<localleader>tr", "<cmd>set number! norelativenumber!<cr>", { desc = "Hybrid line numbers" })

-- Toggle options
vim.keymap.set("n", "\\b", '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"; print(vim.o.bg)<CR>', {desc= "Toggle 'background'" })
vim.keymap.set("n", "\\c", "<Cmd>setlocal cursorline! cursorline?<CR>", { desc= "Toggle 'cursorline'" })
vim.keymap.set("n", "\\C", "<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>", {desc= "Toggle 'cursorcolumn'" })
vim.keymap.set("n", "\\d", function() print(toggle_diagnostic())end, {desc= "Toggle diagnostic" })
vim.keymap.set("n", "\\h", '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>', {desc= "Toggle search highlight" })
vim.keymap.set("n", "\\i", "<Cmd>setlocal ignorecase! ignorecase?<CR>", {desc= "Toggle 'ignorecase'" })
vim.keymap.set("n", "\\l", "<Cmd>setlocal list! list?<CR>", {desc= "Toggle 'list'" })
vim.keymap.set("n", "\\n", "<Cmd>setlocal number! number?<CR>", {desc= "Toggle 'number'" })
vim.keymap.set("n", "\\r", "<Cmd>setlocal relativenumber! relativenumber?<CR>", {desc= "Toggle 'relativenumber'" })
vim.keymap.set("n", "\\s", "<Cmd>setlocal spell! spell?<CR>", {desc= "Toggle 'spell'" })
vim.keymap.set("n", "\\w", "<Cmd>windo set wrap<CR>", {desc= "Set 'wrap'" })
vim.keymap.set("n", "\\W", "<Cmd>windo set nowrap<CR>", {desc= "Set 'nowrap'" })


require("legendary").setup()
require("which-key").setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
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
  b = {
    name = "+buffer",
  },
  d = {
    name = "+debug",
    s = {
      name = "Step",
    },
    t = {
      name = "Telescope",
    },
    u = {
      name = "Dap UI",
    },
  },
  f = {
    name = "+format",
  },
  h = {
    name = "+hunk",
  },
  i = {
    name = "+insert",
  },
  l = {
    name = "+language",
  },
  m = {
    name = "+bookmarks",
  },
  n = {
    name = "notes",
  },
  r = {
    name = "+refactor",
  },
  t = {
    name = "+terminal",
  },
  w = {
    name = "+window",
  },
}

local local_leader_mappings = {
  g = {
    name = "+git",
    m = {
      name = "+merge",
    },
  },
  m = {
    name = "+misc",
    s = {
      name = "+schema",
    },
  },
  p = {
    name = "+project",
    s = {
      name = "+session",
    },
  },
  s = {
    name = "+search",
  },
  t = {
    name = "+toggle",
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
