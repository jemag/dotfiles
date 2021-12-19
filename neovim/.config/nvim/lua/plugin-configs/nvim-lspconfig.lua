local home = os.getenv('HOME')
local border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
vim.cmd [[autocmd ColorScheme * highlight! link NormalFloat Normal]]
-- configuring diagnostics signs
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsDefaultError", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsDefaultWarning", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "🛈", texthl = "LspDiagnosticsDefaultInformation", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "!", texthl = "LspDiagnosticsDefaultHint", numhl = "LspDiagnosticsDefaultHint"})

local function on_init(client)
  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end
end

local map = require'utils'.map_key
local function map_keys()
  map('n', '<leader>lD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', '<leader>ld','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', '<C-q>','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lh','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '<leader>ls','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('i', '<C-q>','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', '<leader>li','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<leader>lt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n', '<leader>lw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n', '<leader>lW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  -- ACTION mappings
  map('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n', '<leader>lR',  '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- Few language severs support these three
  map('n', '<leader>fF',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
  -- Diagnostics mapping
  map('n', '<leader>ll', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>')
  map('n', '<leader>lc', '<cmd>lua vim.diagnostic.open_float(0, {scope="cursor"})<CR>')
  map('n', '<leader>ln', '<cmd>lua vim.diagnostic.goto_next{float=false}<CR>')
  map('n', '<leader>lN', '<cmd>lua vim.diagnostic.goto_prev{float=false}<CR>')
  map('n', '<leader>lq', '<cmd>lua vim.diagnostic.setqflist()<CR>')
  map('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>")
  map('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>")
  map('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>")
  map('n', '<F12>', "<cmd>lua require'dap'.step_out()<CR>")
  map('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
  map('n', '<leader>dB', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
  map('n', '<leader>dp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
  map('n', '<leader>dr', "<cmd>lua require'dap'.repl.open()<CR>")
  map('n', '<leader>dl', "<cmd>lua require'dap'.repl.run_last()<CR>")
end

local function on_attach_common(client, bufnr)
  print(client.name..' started')
  if client.resolved_capabilities.document_highlight then
    require'illuminate'.on_attach(client)
  end
  if client.resolved_capabilities.signature_help then
    require'lsp_signature'.on_attach({
       bind = true,
       handler_opts = {
         border = "single"
      }
    })
  end
  if client.resolved_capabilities.hover then
    vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  end
  map_keys()
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.workspace.configuration = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    };
    handlers = {},
    capabilities = capabilities;
    on_init = on_init;
    on_attach = on_attach_common;
  }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.set_log_level(0)

local lsp_installer = require("nvim-lsp-installer")

local function setup_servers()
  local servers = {
    "bashls",
    "angularls",
    "pyright",
    "terraformls",
    "jsonls",
    "clangd",
    "rust_analyzer",
    "vimls",
    "dockerls",
    "html",
    "tsserver",
    "sumneko_lua",
  }

  for _, name in pairs(servers) do
    local ok, server = lsp_installer.get_server(name)
    -- Check that the server is supported in nvim-lsp-installer
    if ok then
      if not server:is_installed() then
        print("Installing " .. name)
        server:install()
      end
    end
  end
end

lsp_installer.on_server_ready(function(server)
	-- Specify the default options which we'll use for pyright and solargraph
	-- Note: These are automatically setup from nvim-lspconfig. See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
	local default_opts = make_config()
	-- Now we'll create a server_opts table where we'll specify our custom LSP server configuration
	local server_opts = {
		["sumneko_lua"] = function()
      return require("lua-dev").setup({
      library = {
        vimruntime = true,
        types = true,
        plugins = false
      },
      lspconfig = {
        on_attach = on_attach_common,
      },
    })
		end,
	}

	-- We check to see if any custom server_opts exist for the LSP server, if so, load them, if not, use our default_opts
	server:setup(server_opts[server.name] and server_opts[server.name]() or default_opts)
	vim.cmd([[ do User LspAttachBuffers ]])
end)
setup_servers()

require'lspconfig'.gopls.setup{
  on_attach = on_attach_common,
  filetypes = {"go", "gomod"},
  capabilities = capabilities
}

-- Configure handlers
vim.lsp.handlers["textDocument/codeAction"] = require'fzf_lsp'.code_action_handler
vim.lsp.handlers["textDocument/definition"] = require'fzf_lsp'.definition_handler
vim.lsp.handlers["textDocument/declaration"] = require'fzf_lsp'.declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require'fzf_lsp'.type_definition_handler
vim.lsp.handlers["textDocument/implementation"] = require'fzf_lsp'.implementation_handler
vim.lsp.handlers["textDocument/references"] = require'fzf_lsp'.references_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require'fzf_lsp'.document_symbol_handler
vim.lsp.handlers["workspace/symbol"] = require'fzf_lsp'.workspace_symbol_handler
vim.lsp.handlers["callHierarchy/incomingCalls"] = require'fzf_lsp'.incoming_calls_handler
vim.lsp.handlers["callHierarchy/outgoingCalls"] = require'fzf_lsp'.outgoing_calls_handler
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
}
)

local nvim_fzf = require("fzf")
require'jdtls.ui'.pick_one_async = function(items, prompt, label_fn, cb)
  coroutine.wrap(function()
    local lines = {}

    for i, a in ipairs(items) do
      a["idx"] = i
      lines[i] = a["idx"] .. ". " .. a["title"]
    end

    local result_table = nvim_fzf.fzf(lines)
    if result_table then
      local idx = tonumber(result_table[1]:match("(%d+)[.]"))
      cb(items[idx])
    end
  end)()
end

local function on_attach_java(client)
  require'illuminate'.on_attach(client)
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require('jdtls').setup.add_commands()
  require'lsp_signature'.on_attach({
    bind = true,
    handler_opts = {
      border = "single"
    }
  })
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  map('n', '<leader>lD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', '<leader>ld','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', '<C-q>','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lh','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '<leader>ls','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('i', '<C-q>','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', '<leader>li','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<leader>lt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n', '<leader>lw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n', '<leader>lW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  -- ACTION mappings
  map('n', '<leader>la', "<Cmd>lua require'jdtls'.code_action()<CR>")
  map('v', '<leader>la', "<Esc><Cmd>lua require'jdtls'.code_action(true)<CR>")
  map('n', '<leader>lA', "<Cmd>lua require'jdtls'.code_action(false, 'refactor')<CR>")
  map('n', '<leader>lR',  '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- Few language severs support these three
  map('n', '<leader>fF',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
  -- Diagnostics mapping
  map('n', '<leader>ll', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>')
  map('n', '<leader>lc', '<cmd>lua vim.diagnostic.open_float(0, {scope="cursor"})<CR>')
  map('n', '<leader>ln', '<cmd>lua vim.diagnostic.goto_next{float=false}<CR>')
  map('n', '<leader>lN', '<cmd>lua vim.diagnostic.goto_prev{float=false}<CR>')
  map('n', '<leader>lq', '<cmd>lua vim.diagnostic.setqflist()<CR>')

  map("n", "<leader>uo", "<Cmd>lua require'jdtls'.organize_imports()<CR>")
  map("n", "<leader>ut", "<Cmd>lua require'jdtls'.test_class({ config = { console = 'console' }})<CR>")
  map("n", "<leader>uT", "<Cmd>lua require'jdtls'.test_nearest_method({ config = { console = 'console' }})<CR>")
  map("v", "<leader>ue", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
  map("n", "<leader>ue", "<Cmd>lua require('jdtls').extract_variable()<CR>")
  map("v", "<leader>um", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")
  map('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>")
  map('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>")
  map('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>")
  map('n', '<F12>', "<cmd>lua require'dap'.step_out()<CR>")
  map('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
  map('n', '<leader>dB', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
  map('n', '<leader>dp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
  map('n', '<leader>dr', "<cmd>lua require'dap'.repl.open()<CR>")
  map('n', '<leader>dl', "<cmd>lua require'dap'.repl.run_last()<CR>")
end


function Start_jdt()
  local dap = require('dap')

  dap.defaults.fallback.external_terminal = {
    command = '/usr/bin/alacritty';
    args = {'-e'};
  }

  local bundles= {vim.fn.glob("/home/jemag/dev/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")}
  vim.list_extend(bundles, vim.split(vim.fn.glob("/home/jemag/dev/vscode-java-test/server/*.jar"), "\n"))
  print("jdtls started")
  local root_markers = {'build.gradle', 'pom.xml', '.git'}
  local root_dir = require('jdtls.setup').find_root(root_markers)
  local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

  -- For Gradle only, removes the .settings folder, otherwise it often timeouts
  --[[ if root_dir ~=nil then
  os.execute("rm -rf " .. root_dir .. "/.settings")
end ]]
local config = make_config()
config.cmd = {'java-lsp.sh', workspace_folder}
config.settings = {
  java = {
    signatureHelp = { enabled = true };
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*"
      }
    };
    sources = {
      organizeImports = {
        starThreshold = 9999;
        staticStarThreshold = 9999;
      };
    };
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      }
    };
  };
}
config.init_options = {
  bundles = bundles,
}
config.on_attach = function(client)
  on_attach_java(client)
end

require('jdtls').start_or_attach(config)

end;

vim.cmd("autocmd FileType java lua Start_jdt()")
vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float(0, {scope='cursor'})")
