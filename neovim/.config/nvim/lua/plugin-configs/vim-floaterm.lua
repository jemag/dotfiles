vim.g.floaterm_width = 0.98
vim.g.floaterm_height = 0.95
vim.g.floaterm_winblend = 9
vim.keymap.set("n", "<leader>t;", "<cmd>FloatermNew<cr>", { desc = "New Floaterm" })
vim.keymap.set("n", "<leader>tc", "<cmd>FloatermNew! cd %:p:h<cr>", { desc = "Floaterm current directory" })
vim.keymap.set("n", "<leader>td", "<cmd>FloatermNew lazydocker<cr>", { desc = "Docker" })
vim.keymap.set("n", "<leader>tf", "<cmd>FloatermNew fzf<cr>", { desc = "Fzf" })
vim.keymap.set("n", "<leader>tg", "<cmd>FloatermNew lazygit<cr>", { desc = "Git" })
vim.keymap.set("n", "<leader>th", "<cmd>FloatermPrev<cr>", { desc = "Floaterm prev" })
vim.keymap.set("n", "<F7>", "<cmd>FloatermPrev<cr>", { desc = "Floaterm prev" })
vim.cmd([[ tnoremap <silent> <F7> <C-\><C-n>:FloatermPrev<CR>]])
vim.keymap.set("n", "<leader>tk", "<cmd>FloatermKill<cr>", { desc = "Floaterm kill" })
vim.keymap.set("n", "<leader>tl", "<cmd>FloatermNext<cr>", { desc = "Floaterm next" })
vim.keymap.set("n", "<F8>", "<cmd>FloatermNext<cr>", { desc = "Floaterm next" })
vim.cmd([[ tnoremap <silent> <F8> <C-\><C-n>:FloatermNext<CR>]])
vim.keymap.set("n", "<leader>tn", "<cmd>FloatermNew node<cr>", { desc = "Node" })
vim.keymap.set("n", "<leader>tp", "<cmd>FloatermNew python<cr>", { desc = "Python" })
vim.keymap.set("n", "<leader>tv", "<cmd>FloatermNew vifm<cr>", { desc = "Vifm" })
vim.keymap.set("n", "<leader>tt", "<cmd>FloatermToggle<cr>", { desc = "Toggle floaterm" })
vim.keymap.set({ "n", "t" }, "<F9>", "<cmd>FloatermToggle<cr>", { desc = "Toggle floaterm" })
vim.keymap.set("n", "<leader>ty", "<cmd>FloatermNew ytop<cr>", { desc = "Ytop" })
vim.keymap.set("n", "<leader>ts", "<cmd>FloatermNew ncdu<cr>", { desc = "Ncdu" })
