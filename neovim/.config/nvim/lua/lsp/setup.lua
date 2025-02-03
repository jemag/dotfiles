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

M.init = function()
  define_signs()
  configure_diagnostics()
  -- vim.lsp.set_log_level(0)
end

return M
