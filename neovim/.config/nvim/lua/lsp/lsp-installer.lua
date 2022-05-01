local servers = {
  "bashls",
  "angularls",
  "ansiblels",
  "pyright",
  "terraformls",
  "jsonls",
  "clangd",
  "rust_analyzer",
  "solargraph",
  "vimls",
  "dockerls",
  "html",
  "tsserver",
  "sumneko_lua",
  "yamlls",
  "jsonnet_ls",
  "gopls",
}
require("nvim-lsp-installer").setup({
  ensure_installed = servers,
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})

local lspconfig = require("lspconfig")

local function setup_servers()
  for _, name in pairs(servers) do
    local opts = require("lsp.configs.generic").get_config()

    if name == "jsonls" then
      local jsonls_opts = require("lsp.configs.jsonls")
      opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end
    if name == "ansiblels" then
      local ansiblels_opts = require("lsp.configs.ansiblels")
      opts = vim.tbl_deep_extend("force", ansiblels_opts, opts)
    end
    if name == "sumneko_lua" then
      -- Don't extend default opts because of the lua-dev setup
      opts = require("lsp.configs.sumneko_lua")
    end

    lspconfig[name].setup(opts)
  end
end

setup_servers()
