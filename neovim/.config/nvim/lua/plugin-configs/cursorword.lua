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
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = "*",
  callback = function()
    vim.b.minicursorword_disable = true
  end,
  desc = "Disable cursorword in terminal",
})
require("mini.cursorword").setup({})
