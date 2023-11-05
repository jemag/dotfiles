local tools = {
  "bash-language-server",
  "angular-language-server",
  "ansible-language-server",
  "editorconfig-checker",
  "pyright",
  "terraform-ls",
  "json-lsp",
  "jdtls",
  "java-debug-adapter",
  "java-test",
  "clangd",
  "rust-analyzer",
  "solargraph",
  "vim-language-server",
  "dockerfile-language-server",
  "html-lsp",
  "typescript-language-server",
  "lua-language-server",
  "stylua",
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
  "prettier"
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
      opts = vim.tbl_deep_extend("force", opts, jsonls_opts)
    end
    if name == "clangd" then
      local clangd_opts = require("lsp.configs.clangd")
      opts = vim.tbl_deep_extend("force", opts, clangd_opts)
    end
    if name == "gopls" then
      local gopls_opts = require("lsp.configs.gopls")
      opts = vim.tbl_deep_extend("force", opts, gopls_opts)
    end
    if name == "jsonnet_ls" then
      local jsonnetls_opts = require("lsp.configs.jsonnnetls")
      opts = vim.tbl_deep_extend("force", opts, jsonnetls_opts)
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
      opts = vim.tbl_deep_extend("force", opts, ansiblels_opts)
    end
    if name == "lua_ls" then
      -- Don't extend default opts because of the lua-dev setup
      opts = require("lsp.configs.lua_ls")
    end

    lspconfig[name].setup(opts)
    ::continue::
  end
end

setup_servers()
