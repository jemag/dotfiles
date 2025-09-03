require("advanced_git_search.snacks").setup({
  diff_plugin = "diffview",
})

vim.api.nvim_set_keymap("x", "<leader>sgl", ":AdvancedGitSearch diff_commit_line<CR>", { noremap = true, desc = "Advanced line diff" })
vim.keymap.set("n", "<leader>sgb", "<cmd>AdvancedGitSearch diff_commit_file<CR>", { desc = "Advanced buffer diff" })
vim.keymap.set(
  "n",
  "<leader>sgi",
  "<cmd>AdvancedGitSearch search_log_content<CR>",
  { desc = "Advanced Search inside commit contents" }
)
vim.keymap.set(
  "n",
  "<leader>sgI",
  "<cmd>AdvancedGitSearch search_log_content<CR>",
  { desc = "Advanced Search inside commit contents of the current file" }
)
vim.keymap.set("n", "<leader>sgf",   "<cmd>AdvancedGitSearch diff_branch_file<CR>", { desc = "Advanced Branch file" })
