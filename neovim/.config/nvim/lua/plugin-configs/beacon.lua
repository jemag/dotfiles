local autocmds = {
	beacon_toggle = {
		{ "CmdwinEnter", "*", "let g:beacon_enable=0" },
		{ "CmdlineEnter", "*", "let g:beacon_enable=0" },
		{ "CmdwinLeave", "*", "let g:beacon_enable=1" },
		{ "CmdlineLeave", "*", "let g:beacon_enable=1" },
	},
}
require("utils").nvim_create_augroups(autocmds)
vim.g.beacon_ignore_buffers = { "*git*", "*fugitive*", "*defx*" }
