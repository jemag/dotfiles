require("winshift").setup()
vim.api.nvim_set_keymap("n", "<c-w>M", "<cmd>WinShift<cr>", { noremap = true, desc = "Winshift" })
