-- Count relative line number movements toward jump list if we move by more than 5 lines
vim.api.nvim_set_keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "<Plug>(accelerated_jk_gk)"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "<Plug>(accelerated_jk_gj)"', { noremap = true, expr = true })

