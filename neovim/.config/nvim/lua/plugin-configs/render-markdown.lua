require("render-markdown").setup({})
vim.keymap.set("n", "<localleader>tmv", require("render-markdown").toggle, { desc = "Toggle markdown render" })
