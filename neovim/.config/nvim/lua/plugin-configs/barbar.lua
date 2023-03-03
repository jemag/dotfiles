require("bufferline").setup({
  animation = false,
  auto_hide = true,
  tabpages = true,
  closable = true,
  clickable = true,
  exclude_ft = { "qf" },
  icons = "both",
  icon_separator_active = "▊ ",
  icon_separator_inactive = "",
  maximum_padding = 4,
  maximum_length = 40,
  semantic_letters = true,
})
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
