local tools = {
  "angular-language-server",
  -- "ansible-language-server",
  -- "azure-pipelines-language-server",
  "bash-language-server",
  "black",
  "shfmt",
  "bicep-lsp",
  "clangd",
  "delve",
  "dockerfile-language-server",
  "editorconfig-checker",
  "gofumpt",
  "goimports",
  "goimports-reviser",
  "golangci-lint",
  "golangci-lint-langserver",
  "golines",
  "gomodifytags",
  "gopls",
  "gotests",
  "gotestsum",
  "html-lsp",
  "helm-ls",
  "iferr",
  "impl",
  "java-debug-adapter",
  "java-test",
  "jdtls",
  "json-lsp",
  "jsonnet-language-server",
  "lua-language-server",
  "marksman",
  "prettierd",
  "pyright",
  "rust-analyzer",
  "solargraph",
  "stylua",
  "terraform-ls",
  "tflint",
  "typescript-language-server",
  "vim-language-server",
  "yaml-language-server",
  "yamllint",
  "yamlfmt",
}
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = tools,
})

local lspconfig = require("lspconfig")
local installed_servers = require("mason-lspconfig").get_installed_servers()
local manually_installed_servers = {"nixd"}
vim.list_extend(installed_servers, manually_installed_servers)

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
          settings = {
            yaml = {
              format = {
                enable = false,
              },
            },
          },
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
