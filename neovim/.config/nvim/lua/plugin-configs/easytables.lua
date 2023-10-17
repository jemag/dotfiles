require("easytables").setup({
  set_mappings = function(buf)
    vim.keymap.set({ "n", "i" }, "<Left>", "<cmd>JumpLeft<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<S-Left>", "<cmd>SwapWithLeftCell<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<Right>", "<cmd>JumpRight<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<S-Right>", "<cmd>SwapWithRightCell<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<Up>", "<cmd>JumpUp<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<S-Up>", "<cmd>SwapWithUpperCell<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<Down>", "<cmd>JumpDown<CR>", { buffer = true })
    vim.keymap.set({ "n", "i" }, "<S-Down>", "<cmd>SwapWithLowerCell<CR>", { buffer = true })

    vim.api.nvim_buf_set_keymap(buf, "n", "<C-Left>", ":SwapWithLeftColumn<CR>", {})
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-Right>", ":SwapWithRightColumn<CR>", {})
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-Up>", ":SwapWithUpperRow<CR>", {})
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-Down>", ":SwapWithLowerRow<CR>", {})
  end,
})
