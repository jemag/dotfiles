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
