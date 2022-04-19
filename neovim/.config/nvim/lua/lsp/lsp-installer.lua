require("nvim-lsp-installer").on_server_ready(function(server)
  local opts = require("lsp.configs.generic").get_config()
  if server.name == "jsonls" then
    local jsonls_opts = require("lsp.configs.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end
  if server.name == "ansiblels" then
    local ansiblels_opts = require("lsp.configs.ansiblels")
    opts = vim.tbl_deep_extend("force", ansiblels_opts, opts)
  end

  if server.name == "sumneko_lua" then
    -- Don't extend default opts because of the lua-dev setup
    opts = require("lsp.configs.sumneko_lua")
  end
  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)

local function setup_servers()
  -- java not included, installed manually with nvim-jdtls special config
  local servers = {
    "bashls",
    "angularls",
    -- TODO: fix ansiblels highlight out of range problem
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

  for _, name in pairs(servers) do
    local ok, server = require("nvim-lsp-installer").get_server(name)
    -- Check that the server is supported in nvim-lsp-installer
    if ok then
      if not server:is_installed() then
        print("Installing " .. name)
        server:install()
      end
    end
  end
end

setup_servers()
