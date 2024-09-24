local M = {}

local function define_signs()
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "🛈",
        [vim.diagnostic.severity.HINT] = "!",
      },
    },
  })

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
  vim.lsp.handlers["textDocument/typeDefinition"] = require("telescope.builtin").lsp_type_definitions
  vim.lsp.handlers["textDocument/implementation"] = require("telescope.builtin").lsp_implementations
  vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
  vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols
  vim.lsp.handlers["workspace/symbol"] = require("telescope.builtin").lsp_workspace_symbols
end

M.init = function()
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
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
