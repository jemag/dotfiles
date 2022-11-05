vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi def link IlluminatedWordText IncSearch",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi def link IlluminatedWordRead IncSearch",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi def link IlluminatedWordWrite IncSearch",
})
