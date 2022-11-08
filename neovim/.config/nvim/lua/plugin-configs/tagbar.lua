--Settings for TagBar
--autocmd BufReadPost *.cpp,*.c,*.h,*.go,*.cc,*.py call tagbar#autoopen()
vim.g.tagbar_width = 25
vim.keymap.set("n", "<localleader>tT", "<cmd>TagbarToggle<cr>", { desc = "Tagbar" })
