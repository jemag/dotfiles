require("substitute").setup({
  highlight_substituted_text = {
    enabled = false
  }
})

vim.keymap.set("n", "s", require('substitute').operator, { noremap = true, desc = "Substitute with reg" })
vim.keymap.set(
  "n",
  "<cr>s",
  '"+<cmd>lua require("substitute").operator()<cr>',
  { noremap = true, desc = "Substitute with +reg" }
)
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true, desc = "Substitute with reg" })
vim.keymap.set("n", "<cr>ss", '"+<cmd>lua require("substitute").line()<cr>', {
  noremap = true,
  desc = "Substitute with +reg",
})
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true, desc = "Substitute with reg" })
vim.keymap.set("n", "<cr>S", '"+<cmd>lua require("substitute").eol()<cr>', { noremap = true, desc = "Substitute with +reg" })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true, desc = "Substitute with reg" })
vim.keymap.set(
  "x",
  "<cr>s",
  '"+<cmd>lua require("substitute").visual()<cr>',
  { noremap = true, desc = "Substitute with +reg" }
)
