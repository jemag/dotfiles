return {
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        disable = {
          "different-requires",
          "missing-fields",
        },
        globals = {
          "P",
          "vim",
          "describe",
          "it",
          "before_each",
          "after_each",
          "teardown",
          "pending",
          "clear",
        },
      },
      workspace = {
        checkThirdParty = false,
      }
    },
  },
  capabilities = require("lsp.handlers").capabilities,
  on_attach = require("lsp.handlers").on_attach,
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
}
