--[[ let bufferline = {}
let bufferline.icons = "both"
" Enable/disable animations
let bufferline.animation = true
" Enable/disable close button
let bufferline.closable = true

" Enables/disable clickable tabs
"  - left-click: go to buffer
"  - middle-click: delete buffer
let bufferline.clickable = true

" If set, the letters for each buffer in buffer-pick mode will be
" assigned based on their name. Otherwise or in case all letters are
" already assigned, the behavior is to assign letters in order of
" usability (see order below)
let bufferline.semantic_letters = true

" New buffer letters are assigned in this order. This order is
" optimal for the qwerty keyboard layout but might need adjustement
" for other layouts.
let bufferline.letters =
  \ 'asdfjkl;ghnmxcbziowerutyqpASDFJKLGHNMXCBZIOWERUTYQP'

" Sets the maximum padding width with which to surround each tab
let bufferline.maximum_padding = 4 ]]
vim.cmd([[autocmd ColorScheme * highlight! BufferCurrent guifg=black guibg=#77A8D9]])
vim.cmd([[autocmd ColorScheme * highlight! BufferCurrentIndex guifg=black guibg=#77A8D9]])
vim.cmd([[autocmd ColorScheme * highlight! BufferCurrentSign guifg=#E06C75 guibg=#77A8D9]])
vim.cmd([[autocmd ColorScheme * highlight! BufferCurrentMod guifg=#E06C75 guibg=#77A8D9]])
vim.cmd([[autocmd ColorScheme * highlight! BufferVisible guifg=black guibg=#626A73]])
vim.cmd([[autocmd ColorScheme * highlight! BufferVisibleIndex guifg=black guibg=#626A73]])
vim.cmd([[autocmd ColorScheme * highlight! BufferVisibleSign guifg=#626A73 guibg=#626A73]])
vim.g.bufferline = {
  animation = false,
  auto_hide = false,
  closable = true,
  clickable = true,
  exclude_ft = { "qf" },
  icon_separator_active = "▊ ",
  icons = "both",
  maximum_padding = 4,
  semantic_letters = true,
  maximum_length = 40,
}
vim.api.nvim_set_keymap("n", "H", "<cmd>BufferPrevious<cr>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.api.nvim_set_keymap("n", "L", "<cmd>BufferNext<cr>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set({ "n", "x" }, "<leader>1", "<cmd>BufferGoto 1<cr>", { desc = "Buf 1" })
vim.keymap.set({ "n", "x" }, "<leader>2", "<cmd>BufferGoto 2<cr>", { desc = "Buf 2" })
vim.keymap.set({ "n", "x" }, "<leader>3", "<cmd>BufferGoto 3<cr>", { desc = "Buf 3" })
vim.keymap.set({ "n", "x" }, "<leader>4", "<cmd>BufferGoto 4<cr>", { desc = "Buf 4" })
vim.keymap.set({ "n", "x" }, "<leader>5", "<cmd>BufferGoto 5<cr>", { desc = "Buf 5" })
vim.keymap.set({ "n", "x" }, "<leader>6", "<cmd>BufferGoto 6<cr>", { desc = "Buf 6" })
vim.keymap.set({ "n", "x" }, "<leader>7", "<cmd>BufferGoto 7<cr>", { desc = "Buf 7" })
vim.keymap.set({ "n", "x" }, "<leader>8", "<cmd>BufferGoto 8<cr>", { desc = "Buf 8" })
vim.keymap.set({ "n", "x" }, "<leader>9", "<cmd>BufferGoto 9<cr>", { desc = "Buf 9" })
vim.keymap.set({ "n", "x" }, "<leader>0", "<cmd>BufferGoto 10<cr>", { desc = "Buf 10" })
vim.keymap.set({ "n", "x" }, "<leader>bd", "<cmd>BufferClose<cr>", { desc = "Delete-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bD", "<cmd>BufferCloseAllButCurrent<cr>", { desc = "Delete all other buffers" })
vim.keymap.set({ "n", "x" }, "<leader>be", "<cmd>blast<cr>", { desc = "Last-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bf", "<cmd>bfirst<cr>", { desc = "First-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bh", "<cmd>BufferMovePrevious<cr>", { desc = "move prev" })
vim.keymap.set({ "n", "x" }, "<leader>bl", "<cmd>BufferMoveNext<cr>", { desc = "move next" })
vim.keymap.set({ "n", "x" }, "<leader>br", "<cmd>BufferCloseBuffersRight<cr>", { desc = "delete buffers to the right" })
vim.keymap.set({ "n", "x" }, "<leader>bn", "<cmd>BufferNext<cr>", { desc = "Next-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bp", "<cmd>BufferPrevious<cr>", { desc = "Previous-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bs", "<cmd>BufferPick<cr>", { desc = "Magic buffer select" })
