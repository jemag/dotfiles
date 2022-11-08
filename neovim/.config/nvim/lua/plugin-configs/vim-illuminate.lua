vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi def IlluminatedWordText gui=underline",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi def IlluminatedWordRead gui=underline",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "hi def IlluminatedWordWrite gui=underline",
})
