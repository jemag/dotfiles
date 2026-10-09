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
    update_in_insert = false,
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

-- nu-lsp panics on documentSymbol for documents it hasn't opened (crates/nu-lsp/src/symbols.rs).
-- Drop those requests regardless of which plugin sends them.
local function guard_unopened_document_symbols(client)
  local request = client.request
  client.request = function(self, method, params, handler, bufnr)
    if method == "textDocument/documentSymbol" then
      local uri = params and params.textDocument and params.textDocument.uri
      local target = uri and vim.fn.bufnr(vim.uri_to_fname(uri)) or -1
      if target == -1 or not self.attached_buffers[target] then
        vim.lsp.log.warn("dropped documentSymbol for unopened document", uri, debug.traceback())
        if handler then
          vim.schedule(function()
            handler(nil, {}, { method = method, client_id = self.id, bufnr = bufnr })
          end)
        end
        return true, nil
      end
    end
    return request(self, method, params, handler, bufnr)
  end
end

local function setup_default_lsp_config()
  local function on_init(client)
    if client.config.settings then
      client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    if client.name == "nushell" then
      guard_unopened_document_symbols(client)
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
    "terragrunt_ls",
    "tinymist",
    "ts_ls",
    "vimls",
    "gopls",
    "jsonls",
    "tinymist",
    "jsonnet_ls",
    "emmylua_ls",
    "clangd",
    "bicep",
    "ansiblels",
    -- "yamlls",
  }

  for _, server_name in ipairs(lsp_servers) do
    vim.lsp.enable(server_name)
  end

  vim.keymap.set("n", "<leader>lH", function()
    local clients = vim.lsp.get_clients({ name = "harper_ls" })
    if #clients > 0 then
      vim.lsp.enable("harper_ls", false)
      for _, client in ipairs(clients) do
        client:stop()
      end
      vim.notify("Harper disabled")
    else
      vim.lsp.enable("harper_ls")
      vim.notify("Harper enabled")
    end
  end, { desc = "Toggle Harper LSP" })
end

local function init()
  define_signs()
  configure_diagnostics()
  setup_default_lsp_config()
  enable_lsp_servers()
  -- vim.lsp.set_log_level(0)
end

init()
