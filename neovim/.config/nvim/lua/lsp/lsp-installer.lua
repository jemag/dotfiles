local tools = {
  "bash-language-server",
  "angular-language-server",
  "ansible-language-server",
  "pyright",
  "terraform-ls",
  "json-lsp",
  "jdtls",
  "java-debug-adapter",
  "java-test",
  "clangd",
  "rust-analyzer",
  "solargraph",
  "tailwindcss-language-server",
  "vim-language-server",
  "dockerfile-language-server",
  "html-lsp",
  "typescript-language-server",
  {"lua-language-server", version = 'v3.2.2'},
  "yaml-language-server",
  "jsonnet-language-server",
  "gopls",
  "delve",
  "gofumpt",
  "goimports",
  "goimports-reviser",
  "golangci-lint",
  "golangci-lint-langserver",
  "golines",
  "gomodifytags",
  "gotests",
  "gotestsum",
  "iferr",
  "impl",
  "marksman",
}
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = tools,
})

local lspconfig = require("lspconfig")
local installed_servers = require("mason-lspconfig").get_installed_servers()

local function setup_servers()
  for _, name in pairs(installed_servers) do
    local opts = require("lsp.configs.generic").get_config()

    if name == "jsonls" then
      local jsonls_opts = require("lsp.configs.jsonls")
      opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end
    if name == "yamlls" then
      local yamlls_opts = require("yaml-companion").setup({
        lspconfig = {
          on_attach = require("lsp.handlers").on_attach,
        },
      })
      opts = yamlls_opts
    end
    if name == "jdtls" then
      goto continue
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
    ::continue::
  end
end

setup_servers()
