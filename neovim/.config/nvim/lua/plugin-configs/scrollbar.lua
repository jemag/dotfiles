local autocmds = {
	ScrollbarInit = {
		{"CursorMOved",     "*",   "silent! lua require('scrollbar').show()"};
		{"VimResized",     "*",   "silent! lua require('scrollbar').show()"};
		{"QuitPre",     "*",   "silent! lua require('scrollbar').show()"};
		{"WinEnter",     "*",   "silent! lua require('scrollbar').show()"};
		{"FocusGained",     "*",   "silent! lua require('scrollbar').show()"};
		{"WinLeave",     "*",   "silent! lua require('scrollbar').clear()"};
		{"FOcusLost",     "*",   "silent! lua require('scrollbar').clear()"};
		{"BufLeave",     "*",   "silent! lua require('scrollbar').clear()"};
	};
}
require'utils'.nvim_create_augroups(autocmds);
vim.g.scrollbar_max_size = 10;
vim.g.scrollbar_min_size = 3;
vim.g.scrollbar_max_size = 10;
vim.g.scrollbar_shape = {
     head = '',
     body = '█',
     tail = '',
}

vim.g.scrollbar_excluded_filetypes = {'NvimTree', 'fzf', 'defx', 'vista', 'tagbar', 'vifm', 'startify'}
