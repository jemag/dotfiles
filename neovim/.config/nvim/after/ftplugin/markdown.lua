vim.opt_local.conceallevel = 2
vim.opt_local.expandtab = true

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
