vim.g.mapleader = " "
vim.g.maplocalleader = "-"
require("plugins")
require("keybindings")
require("globals")
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1

require("settings")
local autocmds = {
	gui = {
		{ "UIEnter", "*", "GuiFont! FuraCode Nerd Font Mono:h9" },
	},
	min_lines = {
		{ "CursorHold", "*?", "syntax sync minlines=300" },
	},
}
require("utils").nvim_create_augroups(autocmds)

vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")
