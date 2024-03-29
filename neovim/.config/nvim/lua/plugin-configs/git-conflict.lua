require("git-conflict").setup()
vim.keymap.set("n", "<leader>gmb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Both" })
vim.keymap.set("n", "<leader>gmj", "<cmd>GitConflictNextConflict<cr>", { desc = "Next conflict" })
vim.keymap.set("n", "<leader>gmk", "<cmd>GitConflictPrevConflict<cr>", { desc = "Prev conflict" })
vim.keymap.set("n", "<leader>gmn", "<cmd>GitConflictChooseNone<cr>", { desc = "None" })
vim.keymap.set("n", "<leader>gmq", "<cmd>GitConflictListQf<cr>", { desc = "Quickfix conflicts" })
vim.keymap.set("n", "<leader>gmo", "<cmd>GitConflictChooseOurs<cr>", { desc = "Ours" })
vim.keymap.set("n", "<leader>gmt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Theirs" })
