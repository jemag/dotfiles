local utils = require("utils")
local buffer_diagnostic_state = {}
local toggle_diagnostic = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_state = buffer_diagnostic_state[buf_id]
  if buf_state == nil then
    buf_state = true
  end

  if buf_state then
    vim.diagnostic.disable(buf_id)
  else
    vim.diagnostic.enable(buf_id)
  end

  local new_buf_state = not buf_state
  buffer_diagnostic_state[buf_id] = new_buf_state

  return new_buf_state and "  diagnostic" or "nodiagnostic"
end

vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "enter insert mode with proper indent" })
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

vim.keymap.set({ "n", "x" }, "c", '"_c', { desc = "Change without yank" })
vim.keymap.set({ "n", "x" }, "C", '"_C', { desc = "Change without yank" })
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
-- NOTE: could potentially use 'go' and 'gO' as well if we wanted to keep letter 'o' with leader key for more keybinds
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
vim.api.nvim_set_keymap("t", "<c-o>", [[<C-\><C-n><esc><cr>]], { noremap = true, silent = true, desc = "Normal mode" })

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

vim.keymap.set({ "n", "x" }, "<leader>.", "<cmd>e $MYVIMRC<cr>", { desc = "Open init" })
vim.keymap.set({ "n", "x" }, "<leader>nw", "<cmd>e ~/working-memory.md<cr>", { desc = "Working memory" })
vim.keymap.set("n", "<leader>fb", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format" })
vim.keymap.set("n", "<leader>wt", "<cmd>tabclose<CR>", { desc = "Close tab" })
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

-- Diffs
vim.keymap.set("n", "<localleader>md", function()
  local split_filenames = {}
  for _, buf in ipairs(vim.fn.getbufinfo()) do
    if buf.hidden == 0 and buf.listed == 1 then
      table.insert(split_filenames, buf.name)
    end
  end
  if #split_filenames == 2 then
    vim.cmd.tabnew(split_filenames[1])
    vim.cmd("vertical diffsplit " .. split_filenames[2])
    vim.cmd.normal({ args = { "gg" }, bang = true })
  else
    vim.notify("Can't diff with more than 2 files open")
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

require("legendary").setup()
