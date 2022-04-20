return require("lua-dev").setup({
  library = {
    vimruntime = true,
    types = true,
    plugins = false,
  },
  lspconfig = {
    settings = {
      Lua = {
        diagnostics = {
          enable = true,
          disable = {
            "different-requires",
          },
          globals = {
            "vim", "describe", "it", "before_each", "after_each", "teardown", "pending", "clear"
          }
        },
      },
    },
    capabilities = require("lsp.handlers").capabilities,
    on_attach = require("lsp.handlers").on_attach,
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
  },
})
