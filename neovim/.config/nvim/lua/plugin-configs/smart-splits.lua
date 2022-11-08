require('smart-splits').setup({
  -- enable or disable the tmux Integration
  tmux_integration = false,
})
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left win" })
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to win under" })
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to win above" })
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right win" })

-- resizing splits
vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left, { desc = "Resize left" })
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down, { desc = "Resize down" })
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up, { desc = "Resize up" })
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right, { desc = "Resize right" })

