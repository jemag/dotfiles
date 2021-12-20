vim.api.nvim_set_keymap("n", "<localleader>ti", "<cmd>IndentBlanklineToggle<CR>", { noremap = true, silent = true })
vim.cmd([[autocmd ColorScheme * highlight! IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[autocmd ColorScheme * highlight! IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[autocmd ColorScheme * highlight! IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[autocmd ColorScheme * highlight! IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[autocmd ColorScheme * highlight! IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[autocmd ColorScheme * highlight! IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

require("indent_blankline").setup({
	char = "|",
	enabled = false,
	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
	filetype_exclude = {
		"help",
		"terminal",
		"dashboard",
		"nofile",
		"packer",
		"lspinfo",
		"TelescopePrompt",
		"TelescopeResults",
	},
})
