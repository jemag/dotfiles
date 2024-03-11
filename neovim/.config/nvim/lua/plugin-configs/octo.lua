require("octo").setup()
vim.keymap.set({ "n", "x" }, "<leader>go", "<cmd>Octo actions<cr>", { desc = "Octo actions" })
