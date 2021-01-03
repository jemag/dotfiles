autocmd CursorHold * silent lua vim.lsp.diagnostic.show_line_diagnostics()
lua <<EOF
-- highlights for vim illuminate
vim.api.nvim_command [[ hi def link LspReferenceText IncSearch ]]
vim.api.nvim_command [[ hi def link LspReferenceRead IncSearch ]]
vim.api.nvim_command [[ hi def link LspReferenceWrite IncSearch ]]
vim.api.nvim_command [[ hi def link illuminatedCurWord IncSearch ]]

-- util function to map keys
local map = function(type, key, value)
    vim.fn.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

-- GOTO mappings
local map_keys = function()
  map('n', '<leader>lD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', '<leader>ld','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', '<C-q>','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lh','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '<leader>ls','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', '<leader>li','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<leader>lt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n', '<leader>lw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n', '<leader>lW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  -- ACTION mappings
  map('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n', '<leader>lR',  '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- Few language severs support these three
  map('n', '<leader>fF',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
  -- map('n','<leader>ai',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  -- map('n','<leader>ao',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  -- Diagnostics mapping
  map('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n', '<leader>lN', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
end
-- configuring diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
}
)

-- common attach config
local on_attach_common = function(client)
    print("LSP STARTED")
    require'completion'.on_attach(client)
    require'illuminate'.on_attach(client)
    map_keys()
end

require'lspconfig'.tsserver.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.bashls.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.terraformls.setup{
  on_attach = function(client)
  require'completion'.on_attach(client)
  map_keys()
  end,
}

require'lspconfig'.jsonls.setup{
  on_attach = function(client)
  require'completion'.on_attach(client)
  map_keys()
  end,
}

require'lspconfig'.gopls.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.clangd.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.rust_analyzer.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.vimls.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.dockerls.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.html.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.angularls.setup{
  on_attach = function(client)
  on_attach_common(client)
  end,
}

require'lspconfig'.yamlls.setup{
  on_attach = function(client)
  require'completion'.on_attach(client)
  map_keys()
  end,
}
-- require'lspconfig'.jdtls.setup{ on_attach=require'completion'.on_attach }
-- Configure handlers
vim.lsp.handlers["textDocument/codeAction"] = require'fzf_lsp'.code_action_handler
vim.lsp.handlers["textDocument/definition"] = require'fzf_lsp'.definition_handler
vim.lsp.handlers["textDocument/declaration"] = require'fzf_lsp'.declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require'fzf_lsp'.type_definition_handler
vim.lsp.handlers["textDocument/implementation"] = require'fzf_lsp'.implementation_handler
vim.lsp.handlers["textDocument/references"] = require'fzf_lsp'.references_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require'fzf_lsp'.document_symbol_handler
vim.lsp.handlers["workspace/symbol"] = require'fzf_lsp'.workspace_symbol_handler
vim.lsp.handlers["callHierarchy/incomingCalls"] = require'fzf_lsp'.incoming_calls_handler
vim.lsp.handlers["callHierarchy/outgoingCalls"] = require'fzf_lsp'.outgoing_calls_handler
EOF
