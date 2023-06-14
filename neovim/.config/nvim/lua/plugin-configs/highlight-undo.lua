require("highlight-undo").setup({
  hlgroup = "HighlightUndo",
  duration = 300,
  keymaps = {
    { "n", "u", "undo", {} },
    { "n", "<C-r>", "redo", {} },
  },
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "HighlightUndo", { link = "Search" })
  end,
})
