vim.g.indent_blankline_char = '|'
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_enabled = false
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile', 'packer'}
vim.api.nvim_set_keymap('n', '<localleader>ti','<cmd>IndentBlanklineToggle<CR>', { noremap = true, silent = true })
