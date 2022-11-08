vim.api.nvim_set_keymap("o", "m", ":<C-U>lua require('tsht').nodes()<CR>", { noremap = true, silent = true, desc = "Treesitter hints" })
vim.api.nvim_set_keymap("x", "m", ":lua require('tsht').nodes()<CR>", { noremap = true, silent = true, desc = "Treesitter hints" })
