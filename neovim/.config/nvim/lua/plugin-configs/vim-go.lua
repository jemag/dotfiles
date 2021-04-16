--vim-go
vim.g.go_fmt_command = "goimports"
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_structs = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_generate_tags = 1
--disable use K to run godoc
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_def_mapping_enabled = 0

--[[ if dein#tap('vim-go')
	 nnoremap <silent> <leader>gi :GoImpl<CR>
	 nnoremap <silent> <Leader>gd :GoDescribe<CR>
	 nnoremap <silent> <Leader>gc :GoCallees<CR>
	 nnoremap <silent> <Leader>gC :GoCallers<CR>
	 nnoremap <silent> <Leader>gs :GoCallstack<CR>
endif ]]
