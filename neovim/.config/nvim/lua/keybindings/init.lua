local utils = require("utils")
local filter_windows = utils.filter_windows

local toggle_diagnostic = function()
  local buf_id = vim.api.nvim_get_current_buf()

  if vim.diagnostic.is_enabled({ bufnr = buf_id }) then
    vim.diagnostic.enable(false, { bufnr = buf_id })
  else
    vim.diagnostic.enable(true, { bufnr = buf_id })
  end
end

local toggle_tabline = function()
  local current_tabline = vim.o.showtabline
  if current_tabline == 0 then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end

vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 and vim.bo.buftype ~= "terminal" then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "enter insert mode with proper indent" })

vim.keymap.set("n", "a", function()
  if #vim.fn.getline(".") == 0 and vim.bo.buftype ~= "terminal" then
    return [["_cc]]
  else
    return "a"
  end
end, { expr = true, desc = "enter insert mode with proper indent" })

vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

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
vim.keymap.set({ "n", "x" }, "<cr>", "<nop>", { desc = "disable <cr> in normal and visual mode" })
-- Testing centering cursor
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll half down with cursor centered" })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll half up with cursor centered" })
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true, desc = "Scroll down with cursor centered" })
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true, desc = "Scroll up with cursor centered" })
vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true, desc = "Next match centered" })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true, desc = "Previous match centered" })

vim.keymap.set({ "n", "x" }, "c", '"_c', { desc = "c without yank" })
vim.keymap.set({ "n", "x" }, "C", '"_C', { desc = "C without yank" })
vim.keymap.set({ "n", "x" }, "x", '"_x', { desc = "x without yank" })
vim.keymap.set({ "n", "x" }, "X", '"_X', { desc = "X without yank" })
vim.api.nvim_set_keymap("n", "'", "`", { noremap = true, silent = true, desc = "Exact position mark" })
vim.keymap.set("n", "gm", function()
  if vim.v.count == 0 then
    vim.api.nvim_feedkeys("^", "n", false)
  else
    vim.api.nvim_feedkeys(vim.v.count * 10 .. "gM", "n", false)
  end
end, { noremap = true, silent = true, desc = "Go to % of current line" })
vim.api.nvim_set_keymap("n", "R", '"_d', { noremap = true, silent = true, desc = "Delete without register" })
vim.api.nvim_set_keymap("n", "<esc>", "<cmd>noh<cr><esc>", { noremap = true, silent = true, desc = "Remove highlight or escape" })
vim.api.nvim_set_keymap("i", "jk", "<esc>", { noremap = true, silent = true, desc = "Escape" })

vim.keymap.set("n", "<c-i>", "<c-i>")

vim.api.nvim_set_keymap("n", "<Right>", "<cmd>lopen<cr>", { noremap = true, silent = true, desc = "Opoen location list" })
vim.api.nvim_set_keymap("n", "<Left>", "<cmd>lclose<cr>", { noremap = true, silent = true, desc = "Close location list" })
vim.api.nvim_set_keymap("n", "<Up>", "<cmd>copen<cr>", { noremap = true, silent = true, desc = "Open quickfix" })
vim.api.nvim_set_keymap("n", "<Down>", "<cmd>cclose<cr>", { noremap = true, silent = true, desc = "Close quickfix" })

vim.api.nvim_set_keymap("i", "<C-u>", "<C-g>u<C-u>", { noremap = true, silent = true, desc = "Delete before cursor" })
vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true, desc = "Visual j" })
vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true, desc = "Visual k" })
vim.keymap.set({ "n", "x" }, "gj", "j", { noremap = true, silent = true, desc = "Normal j" })
vim.keymap.set({ "n", "x" }, "gk", "k", { noremap = true, silent = true, desc = "Normal k" })

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


vim.keymap.set("x", "<localleader>yj", ":YamlToJson<cr>", { desc = "Convert YAML to JSON" })
vim.keymap.set("x", "<localleader>jy", ":JsonToYaml<cr>", { desc = "Convert JSON to YAML" })

vim.keymap.set("x", "Q", ":norm @q<cr>", { desc = "apply macro 'q' over current visual selection" })

vim.keymap.set({ "n", "x" }, ")", "]", { remap = true, desc = "Remap opening parenthesis to bracket" })
vim.keymap.set({ "n", "x" }, "(", "[", { remap = true, desc = "Remap closing parenthesis to bracket" })
--  Reselect latest changed, put, or yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = "Visually select changed text" })
-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
vim.keymap.set("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
vim.keymap.set("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])
vim.api.nvim_set_keymap(
  "n",
  "<cr>o",
  '<cmd>call append(line("."),   repeat([""], v:count1))<CR>',
  { noremap = true, silent = true, desc = "Append line underneath" }
)
vim.api.nvim_set_keymap(
  "n",
  "<cr>O",
  '<cmd>call append(line(".")-1, repeat([""], v:count1))<CR>',
  { noremap = true, silent = true, desc = "Append line above" }
)

vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true, desc = "Yank till end of line" })

vim.api.nvim_set_keymap("i", "<c-w>", "<c-s-w>", { noremap = true })

vim.api.nvim_set_keymap("c", "<esc>", "<c-c>", { noremap = true, desc = "Esc as ctrl-c in command mode" })

vim.api.nvim_set_keymap("n", "<c-w>z", "<c-w>_<c-w>|", { noremap = true, desc = "Zoom current window" })
vim.api.nvim_set_keymap("t", "<c-x>", [[<C-\><C-n><esc><cr>]], { noremap = true, silent = true, desc = "Normal mode" })

vim.api.nvim_set_keymap("x", "<cr>y", '"+y', { noremap = true, silent = true, desc = "Yank +reg" })
vim.api.nvim_set_keymap("n", "<cr>Y", '"+yg_', { noremap = true, silent = true, desc = "Yank end of line +reg" })
vim.api.nvim_set_keymap("n", "<cr>y", '"+y', { noremap = true, silent = true, desc = "Yank +reg" })
vim.api.nvim_set_keymap("n", "<cr>yy", '"+yy', { noremap = true, silent = true, desc = "Yank whole line +reg" })

vim.api.nvim_set_keymap("x", "<cr>c", '"+c', { noremap = true, silent = true, desc = "Change +reg" })
vim.api.nvim_set_keymap("n", "<cr>C", '"+cg_', { noremap = true, silent = true, desc = "Change end of line +reg" })
vim.api.nvim_set_keymap("n", "<cr>c", '"+c', { noremap = true, silent = true, desc = "Change +reg" })
vim.api.nvim_set_keymap("n", "<cr>cc", '"+cc', { noremap = true, silent = true, desc = "Change whole line +reg" })

vim.api.nvim_set_keymap("x", "<cr>d", '"+d', { noremap = true, silent = true, desc = "Delete +reg" })
vim.api.nvim_set_keymap("n", "<cr>D", '"+dg_', { noremap = true, silent = true, desc = "Delete end of line +reg" })
vim.api.nvim_set_keymap("n", "<cr>d", '"+d', { noremap = true, silent = true, desc = "Delete +reg" })
vim.api.nvim_set_keymap("n", "<cr>dd", '"+dd', { noremap = true, silent = true, desc = "Delete whole line +reg" })

vim.api.nvim_set_keymap("n", "<cr>p", '"+p', { noremap = true, silent = true, desc = "Paste after +reg" })
vim.api.nvim_set_keymap("n", "<cr>P", '"+P', { noremap = true, silent = true, desc = "Paste before +reg" })
vim.api.nvim_set_keymap("x", "<cr>p", '"+p', { noremap = true, silent = true, desc = "Paste after +reg" })
vim.api.nvim_set_keymap("x", "<cr>P", '"+P', { noremap = true, silent = true, desc = "Paste before +reg" })

vim.keymap.set({ "n", "x" }, "<localleader>nw", "<cmd>e ~/working-memory.md<cr>", { desc = "Working memory" })

vim.keymap.set("n", "]t", function()
  vim.cmd.tabnext()
end, { desc = "Next tab" })
vim.keymap.set("n", "[t", function()
  vim.cmd.tabprevious()
end, { desc = "Previous tab" })
vim.keymap.set("n", "<leader>wt", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>wn", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<localleader>tr", "<cmd>set number! norelativenumber!<cr>", { desc = "Hybrid line numbers" })

-- Toggle options
vim.keymap.set(
  "n",
  "\\b",
  '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"; print(vim.o.bg)<CR>',
  { desc = "Toggle 'background'" }
)
vim.keymap.set("n", "\\c", "<Cmd>setlocal cursorline! cursorline?<CR>", { desc = "Toggle 'cursorline'" })
vim.keymap.set("n", "\\C", "<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>", { desc = "Toggle 'cursorcolumn'" })
vim.keymap.set("n", "\\d", function()
  print(toggle_diagnostic())
end, { desc = "Toggle diagnostic" })
vim.keymap.set("n", "\\t", function()
  toggle_tabline()
end, { desc = "Toggle tabline" })
vim.keymap.set(
  "n",
  "\\h",
  '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>',
  { desc = "Toggle search highlight" }
)
vim.keymap.set("n", "\\i", "<Cmd>setlocal ignorecase! ignorecase?<CR>", { desc = "Toggle 'ignorecase'" })
vim.keymap.set("n", "\\l", "<Cmd>setlocal list! list?<CR>", { desc = "Toggle 'list'" })
vim.keymap.set("n", "\\n", "<Cmd>setlocal number! number?<CR>", { desc = "Toggle 'number'" })
vim.keymap.set("n", "\\r", "<Cmd>setlocal relativenumber! relativenumber?<CR>", { desc = "Toggle 'relativenumber'" })
vim.keymap.set("n", "\\s", "<Cmd>setlocal spell! spell?<CR>", { desc = "Toggle 'spell'" })
vim.keymap.set("n", "\\w", function()
  utils.windo_restore_win("set wrap")
end, { desc = "Set 'wrap'" })
vim.keymap.set("n", "\\W", function()
  utils.windo_restore_win("set nowrap")
end, { desc = "Set 'nowrap'" })

--- Get list of active buffeers from current list of windows
---@param windows number[]
---@return number[]
local function get_shown_buffers(windows)
  local buf_numbers = {}
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufinfo = vim.fn.getbufinfo(buf)[1]
    if bufinfo.hidden == 0 and bufinfo.listed == 1 then
      buf_numbers[#buf_numbers + 1] = buf
    end
  end
  return buf_numbers
end

-- Diffs between current windows
vim.keymap.set("n", "<localleader>md", function()
  local windows = vim.api.nvim_list_wins()
  local buf_numbers = get_shown_buffers(windows)
  if #buf_numbers == 2 then
    vim.cmd.tabnew(vim.fn.getbufinfo(buf_numbers[1])[1].name)
    vim.cmd("vertical diffsplit " .. vim.fn.getbufinfo(buf_numbers[2])[1].name)
    vim.cmd.normal({ args = { "gg" }, bang = true })
  else
    local first_win = require("snacks").picker.util.pick_win({ filter = filter_windows })
    if first_win == nil then
      return
    end
    local second_win = require("snacks").picker.util.pick_win({ filter = filter_windows })
    if second_win == nil then
      return
    end
      local first_bufnumber = vim.api.nvim_win_get_buf(first_win)
      local second_bufnumber = vim.api.nvim_win_get_buf(second_win)
      local first_buf = vim.fn.getbufinfo(first_bufnumber)[1]
      local second_buf = vim.fn.getbufinfo(second_bufnumber)[1]
      vim.cmd.tabnew(first_buf.name)
      vim.cmd("vertical diffsplit " .. second_buf.name)
      vim.cmd.normal({ args = { "gg" }, bang = true })
  end
end, { desc = "Diff between open files" })

vim.keymap.set("x", "<localleader>md", function()
  vim.cmd('noau normal! "vy')
  local filetype = vim.bo.filetype
  vim.cmd.tabnew()
  vim.cmd('noau normal! "0P')
  vim.bo.filetype = filetype
  vim.bo.buftype = "nowrite"
  vim.cmd.diffthis()
  vim.cmd.vsplit()
  vim.cmd.ene()
  vim.cmd('noau normal! "vP')
  vim.bo.filetype = filetype
  vim.bo.buftype = "nowrite"
  vim.cmd.diffthis()
end, { desc = "Diff selection with clipboard" })
