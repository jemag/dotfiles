vim.g.bookmark_location_list = 0
-- vim.g.bookmark_no_default_key_mappings = 1
vim.keymap.set({ "n", "v" }, "<leader>ma", "<cmd>BookmarkShowAll<cr>", { desc = "Show all" })
vim.keymap.set({ "n", "v" }, "<leader>mc", "<cmd>BookmarkClear<cr>", { desc = "Clear" })
vim.keymap.set({ "n", "v" }, "<leader>mi", "<cmd>BookmarkAnnotate<cr>", { desc = "Annotate" })
vim.keymap.set({ "n", "v" }, "<leader>mj", "<cmd>BookmarkMoveDown<cr>", { desc = "Move down" })
vim.keymap.set({ "n", "v" }, "<leader>mk", "<cmd>BookmarkMoveUp<cr>", { desc = "Move up" })
vim.keymap.set({ "n", "v" }, "<leader>mm", "<cmd>BookmarkToggle<cr>", { desc = "Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>mn", "<cmd>BookmarkNext<cr>", { desc = "Next bookmark" })
vim.keymap.set({ "n", "v" }, "<leader>mp", "<cmd>BookmarkPrev<cr>", { desc = "Prev bookmark" })
vim.keymap.set({ "n", "v" }, "<leader>ms", "<cmd>Telescope vim_bookmarks all<cr>", { desc = "Search all annotated bookmarks" })
vim.keymap.set({ "n", "v" }, "<leader>mS", "<cmd>Telescope vim_bookmarks current_file<cr>",
  { desc = "Search current file annotated bookmarks" })
vim.keymap.set({ "n", "v" }, "<leader>mx", "<cmd>BookmarkClearAll<cr>", { desc = "Clear all" })
