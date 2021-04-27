vim.g.indent_blankline_char = '|'
vim.g.indent_blankline_show_current_context = true
-- vim.g.indent_blankline_enabled = true
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile', 'packer'}
local map = require'utils'.map_key
map('n', '<localleader>ti','<cmd>IndentBlanklineToggle<CR>')
