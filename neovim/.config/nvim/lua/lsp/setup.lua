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
      source = "always",
      header = "",
      -- prefix = "",
    },
  }

  vim.diagnostic.config(config)
end

local function setup_default_lsp_config()
  local function on_init(client)
    if client.config.settings then
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
  end

  vim.lsp.config("*", {
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
    capabilities = require("lsp.handlers").capabilities,
    on_attach = require("lsp.handlers").on_attach,
    on_init = on_init,
  })
end

local function enable_lsp_servers()
  local lsp_servers = {
    "angularls",
    "bashls",
    "dockerls",
    "golangci_lint_ls",
    "html",
    "helm_ls",
    "marksman",
    "nixd",
    "nushell",
    "rust_analyzer",
    "solargraph",
    "terraformls",
    "tinymist",
    "ts_ls",
    "vimls",
    "gopls",
    "jsonls",
    "tinymist",
    "jsonnet_ls",
    "harper_ls",
    "emmylua_ls",
    "clangd",
    "bicep",
    "ansiblels",
    "yamlls",
  }

  for _, server_name in ipairs(lsp_servers) do
    vim.lsp.enable(server_name)
  end
end

local function init()
  define_signs()
  configure_diagnostics()
  setup_default_lsp_config()
  enable_lsp_servers()
  -- vim.lsp.set_log_level(0)
end

init()
