require("hop").setup({})
vim.api.nvim_create_autocmd({ "ColorScheme"}, {
  pattern = "*",
  command = "highlight! HopNextKey guifg=#ed333b",
})
