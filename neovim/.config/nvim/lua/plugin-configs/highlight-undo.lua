require("highlight-undo").setup({
  hlgroup = "HighlightUndo",
  duration = 300,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "HighlightUndo", { link = "Search" })
  end,
})
