vim.api.nvim_set_keymap("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true, desc = "Substitute with reg" })
vim.api.nvim_set_keymap(
  "n",
  "<leader>s",
  '"+<cmd>lua require("substitute").operator()<cr>',
  { noremap = true, desc = "Substitute with +reg" }
)
vim.api.nvim_set_keymap("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true, desc = "Substitute with reg" })
vim.api.nvim_set_keymap("n", "<leader>ss", '"+<cmd>lua require("substitute").line()<cr>', {
  noremap = true,
  desc = "Substitute with +reg",
})
vim.api.nvim_set_keymap("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true, desc = "Substitute with reg" })
vim.api.nvim_set_keymap("n", "<leader>S", '"+<cmd>lua require("substitute").eol()<cr>', { noremap = true, desc = "Substitute with +reg" })
vim.api.nvim_set_keymap("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true, desc = "Substitute with reg" })
vim.api.nvim_set_keymap(
  "x",
  "<leader>s",
  '"+<cmd>lua require("substitute").visual()<cr>',
  { noremap = true, desc = "Substitute with +reg" }
)
