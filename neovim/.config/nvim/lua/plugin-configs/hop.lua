require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
vim.keymap.set(
  { "n", "x", "o" },
  "f",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
  ,
  {}
)
vim.keymap.set(
  { "n", "x", "o" },
  "F",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
  ,
  {}
)
vim.keymap.set(
  { "n", "x", "o" },
  "t",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
  ,
  {}
)
vim.keymap.set(
  { "n", "x", "o" },
  "T",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
  ,
  {}
)
