vim.cmd([[
augroup ScrollbarInit
  autocmd!
  autocmd WinScrolled,VimResized, CursorMoved * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost,QuitPre,TabLeave            * silent! lua require('scrollbar').clear()
augroup end]])
vim.g.scrollbar_max_size = 10
vim.g.scrollbar_min_size = 3
vim.g.scrollbar_shape = {
	head = "",
	body = "█",
	tail = "",
}

vim.g.scrollbar_excluded_filetypes = { "NvimTree", "fzf", "defx", "vista", "tagbar", "vifm", "startify" }
