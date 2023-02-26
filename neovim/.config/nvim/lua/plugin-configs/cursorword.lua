vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi default MiniCursorword guibg=#404755",
  desc = "Set MiniCursorword highlight",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi! MiniCursorwordCurrent gui=nocombine guifg=NONE guibg=NONE",
  desc = "Set MiniCursorword highlight",
})
require("mini.cursorword").setup({})
