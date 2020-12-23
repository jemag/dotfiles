lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.clangd.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.gopls.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.rust_analyzer.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.jdtls.setup{ on_attach=require'completion'.on_attach }
