local tools = {
  "angular-language-server",
  "bash-language-server",
  "bicep-lsp",
  "black",
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
  "helm-ls",
  "html-lsp",
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
  "shfmt",
  "solargraph",
  "stylua",
  "terraform-ls",
  "tflint",
  "typescript-language-server",
  "vim-language-server",
  "yaml-language-server",
  "yamlfmt",
  "yamllint",
  -- "ansible-language-server",
  -- "azure-pipelines-language-server",
}
require("mason-lspconfig").setup({
  ensure_installed = {},
  automatic_enable = false,
})
require("mason-tool-installer").setup({
  ensure_installed = tools,
  run_on_start = false,
  integrations = {
    ["mason-lspconfig"] = false,
    ["mason-null-ls"] = false,
    ["mason-nvim-dap"] = false,
  },
})

local lspconfig = require("lspconfig")
local installed_servers = require("mason-lspconfig").get_installed_servers()
local manually_installed_servers = { "nixd", "nushell" }
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
