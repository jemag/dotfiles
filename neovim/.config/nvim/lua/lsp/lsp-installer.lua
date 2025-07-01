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
  "java-debug-adapter", -- missing
  "java-test",-- missing
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

local function setup_default_config()
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

local function setup_servers()
  -- for _, name in pairs(installed_servers) do
  --   local opts = require("lsp.configs.generic").get_config()
  --
  --   if name == "jsonls" then
  --     local jsonls_opts = require("lsp.configs.jsonls")
  --     opts = vim.tbl_deep_extend("force", opts, jsonls_opts)
  --   end
  --   if name == "clangd" then
  --     local clangd_opts = require("lsp.configs.clangd")
  --     opts = vim.tbl_deep_extend("force", opts, clangd_opts)
  --   end
  --   if name == "gopls" then
  --     local gopls_opts = require("lsp.configs.gopls")
  --     opts = vim.tbl_deep_extend("force", opts, gopls_opts)
  --   end
  --   if name == "jsonnet_ls" then
  --     local jsonnetls_opts = require("lsp.configs.jsonnnetls")
  --     opts = vim.tbl_deep_extend("force", opts, jsonnetls_opts)
  --   end
  --   if name == "yamlls" then
  --     local yamlls_opts = require("yaml-companion").setup({
  --       lspconfig = {
  --         on_attach = require("lsp.handlers").on_attach,
  --         settings = {
  --           yaml = {
  --             format = {
  --               enable = false,
  --             },
  --           },
  --         },
  --       },
  --     })
  --     opts = yamlls_opts
  --   end
  --   if name == "jdtls" then
  --     goto continue
  --   end
  --   if name == "ansiblels" then
  --     local ansiblels_opts = require("lsp.configs.ansiblels")
  --     opts = vim.tbl_deep_extend("force", opts, ansiblels_opts)
  --   end
  --   if name == "lua_ls" then
  --     -- Don't extend default opts because of the lua-dev setup
  --     opts = require("lsp.configs.lua_ls")
  --   end
  --
  --   lspconfig[name].setup(opts)
  --   ::continue::
  -- end
  local configs_dir = "lsp.configs"
  local config_path = vim.fn.stdpath("config") .. "/lua/" .. configs_dir:gsub("%.", "/")

  for name, type in vim.fs.dir(config_path) do
    if type == "file" and name:match("%.lua$") then
      local server_name = name:gsub("%.lua$", "")
      local ok, config = pcall(require, "lsp.configs" .. "." .. server_name)
      if ok then
        vim.lsp.enable(server_name)
        vim.lsp.config(server_name, config)
      else
        vim.notify("Failed to load config for " .. server_name, vim.log.levels.ERROR)
      end
    end
  end
end

local function setup_default_config_servers()
  local default_config_servers = {
    "angularls",
    "bashls",
    "dockerls",
    "golangci_lint_ls",
    "html",
    "marksman",
    "nixd",
    "nushell",
    "rust_analyzer",
    "solargraph",
    "terraformls",
    "tinymist",
    "ts_ls",
    "vimls",
    "yamlls",
  }

  for _, server_name in ipairs(default_config_servers) do
    vim.lsp.enable(server_name)
  end
end

setup_default_config()
setup_default_config_servers()
setup_servers()
