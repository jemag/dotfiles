-- Color name (:help cterm-colors) or ANSI code
vim.g.limelight_conceal_ctermfg = "gray"
vim.g.limelight_conceal_ctermfg = 240

-- Color name (:help gui-colors) or RGB color
vim.g.limelight_conceal_guifg = "DarkGray"
vim.g.limelight_conceal_guifg = "#777777"
vim.keymap.set("n", "<localleader>tL", "<cmd>Limelight!!<cr>", { desc = "Limelight" })
