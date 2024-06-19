require("render-markdown").setup({})
vim.keymap.set("n", "<localleader>tmr", require("render-markdown").toggle, { desc = "Toggle markdown render" })
