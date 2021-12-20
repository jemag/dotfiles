-- local map = require'utils'.map_key
vim.api.nvim_set_keymap(
	"n",
	"n",
	'<cmd>execute("normal! " . v:count1 . "n")<CR><cmd>lua require("hlslens").start()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"N",
	'<cmd>execute("normal! " . v:count1 . "N")<CR><cmd>lua require("hlslens").start()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "*", '*<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "#", '#<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "g*", 'g*<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "g#", 'g#<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
--[[ vim.api.nvim_buf_set_keymap(0,'n', 'n','<cmd>execute("normal! " . v:count1 . "n")<CR><cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0,'n', 'N','<cmd>execute("normal! " . v:count1 . "N")<CR><cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0,'n', '*','*<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0,'n', '#','#<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0,'n', 'g*','g*<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0,'n', 'g#','g#<cmd>lua require("hlslens").start()<CR>', { noremap = true, silent = true }) ]]
