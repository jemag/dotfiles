require('smart-splits').setup({
  -- enable or disable the tmux Integration
  cursor_follows_swapped_bufs = true,
})
-- moving between splits
vim.keymap.set({"n", "t"}, "<C-h>", require("smart-splits").move_cursor_left, { desc = "Left pane" })
vim.keymap.set({"n", "t"}, "<C-j>", require("smart-splits").move_cursor_down, { desc = "Down pane" })
vim.keymap.set({"n", "t"}, "<C-k>", require("smart-splits").move_cursor_up, { desc = "Up pane" })
vim.keymap.set({"n", "t"}, "<C-l>", require("smart-splits").move_cursor_right, { desc = "Right pane" })

-- resizing splits
vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left, { desc = "Resize left" })
vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down, { desc = "Resize down" })
vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up, { desc = "Resize up" })
vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right, { desc = "Resize right" })
-- swapping buffers between windows
-- TODO: Use hydra mode instead to not have to redo c-w each time?
-- TODO: Does not work currently to switch a window from horizontal split to vertical split, like original vim keybinds
-- vim.keymap.set('n', '<C-w>H', require('smart-splits').swap_buf_left, { desc = "Swap with left window"})
-- vim.keymap.set('n', '<C-w>J', require('smart-splits').swap_buf_down, { desc = "Swap with window under"})
-- vim.keymap.set('n', '<C-w>K', require('smart-splits').swap_buf_up, { desc = "Swap with window above"})
-- vim.keymap.set('n', '<C-w>L', require('smart-splits').swap_buf_right, { desc = "Swap with right window"})
