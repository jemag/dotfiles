vim.g.vista_fzf_preview = { "right:60%" }
vim.g.vista_sidebar_width = 70
vim.g.vista_stay_on_open = 0
vim.g.vista_default_executive = "nvim_lsp"
vim.keymap.set("n", "<localleader>tv", "<cmd>Vista!!<cr>", { desc = "Vista bar" })
vim.keymap.set("n", "<localleader>sv", "<cmd>Vista finder<cr>", { desc = "Vista finder" })
