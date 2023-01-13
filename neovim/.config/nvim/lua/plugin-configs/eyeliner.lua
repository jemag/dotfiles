require("eyeliner").setup({
  highlight_on_key = true,
  debug = false,
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ff00ff", bold = true, underline = false })
    vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#00ffff", underline = false })
  end,
})
