vim.keymap.set("i", "<C-f>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

vim.keymap.set("i", "<C-e>", "<Plug>(copilot-accept-word)")
vim.g.copilot_no_tab_map = true
