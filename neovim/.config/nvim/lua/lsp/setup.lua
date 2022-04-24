local M = {}

local function define_signs()
  vim.fn.sign_define(
    "DiagnosticSignError",
    { text = "", texthl = "DiagnosticSignError", numhl = "LspDiagnosticsDefaultError" }
  )
  vim.fn.sign_define(
    "DiagnosticSignWarn",
    { text = "", texthl = "DiagnosticSignWarning", numhl = "LspDiagnosticsDefaultWarning" }
  )
  vim.fn.sign_define(
    "DiagnosticSignInfo",
    { text = "🛈", texthl = "DiagnosticSignInfo", numhl = "LspDiagnosticsDefaultInformation" }
  )
  vim.fn.sign_define(
    "DiagnosticSignHint",
    { text = "!", texthl = "DiagnosticSignHint", numhl = "LspDiagnosticsDefaultHint" }
  )
end

local function configure_diagnostics()
  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      -- prefix = "",
    },
  }

  vim.diagnostic.config(config)
end

local function set_handlers()
  vim.lsp.handlers["textDocument/definition"] = require("telescope.builtin").lsp_definitions
  vim.lsp.handlers["textDocument/declaration"] = require("fzf_lsp").declaration_handler
  vim.lsp.handlers["textDocument/typeDefinition"] = require("telescope.builtin").lsp_type_definitions
  vim.lsp.handlers["textDocument/implementation"] = require("telescope.builtin").lsp_implementations
  vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
  vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols
  vim.lsp.handlers["workspace/symbol"] = require("telescope.builtin").lsp_workspace_symbols
  vim.lsp.handlers["callHierarchy/incomingCalls"] = require("fzf_lsp").incoming_calls_handler
  vim.lsp.handlers["callHierarchy/outgoingCalls"] = require("fzf_lsp").outgoing_calls_handler
end

M.init = function()
  vim.api.nvim_create_autocmd({ "ColorScheme"}, {
    pattern = "*",
    command = "highlight! link NormalFloat Normal",
    desc = "Link NormalFloat to Normal",
  })
  define_signs()
  configure_diagnostics()
  set_handlers()
  -- vim.lsp.set_log_level(0)
end

return M
