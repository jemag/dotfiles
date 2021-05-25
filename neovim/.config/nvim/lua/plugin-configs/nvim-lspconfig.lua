local home = os.getenv('HOME')

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
  map('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n', '<leader>lN', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
end

local function set_lsp_icons()
  require'vim.lsp.protocol'.CompletionItemKind = {
    '';   -- Text          = 1;
    '';   -- Method        = 2;
    'ƒ';   -- Function      = 3;
    '';   -- Constructor   = 4;
    '識';  -- Field         = 5;
    '';   -- Variable      = 6;
    '';   -- Class         = 7;
    'ﰮ';   -- Interface     = 8;
    '';   -- Module        = 9;
    '';   -- Property      = 10;
    '';   -- Unit          = 11;
    '';   -- Value         = 12;
    '了';  -- Enum          = 13;
    '';   -- Keyword       = 14;
    '﬌';   -- Snippet       = 15;
    '';   -- Color         = 16;
    '';   -- File          = 17;
    '渚';  -- Reference     = 18;
    '';   -- Folder        = 19;
    '';   -- EnumMember    = 20;
    '';   -- Constant      = 21;
    '';   -- Struct        = 22;
    '鬒';  -- Event         = 23;
    'Ψ';   -- Operator      = 24;
    '';   -- TypeParameter = 25;
  }
end

local function on_attach_common(client)
  print(client.name..' started')
  if client.resolved_capabilities.document_highlight then
    require'illuminate'.on_attach(client)
  end
  if client.resolved_capabilities.signature_help then
    require'lsp_signature'.on_attach()
  end
  map_keys()
  set_lsp_icons()
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

-- for nvim-lspinstall
local function setup_servers()
  require'lspinstall'.setup()

  if require'lspconfig'.typescript then
    require'lspconfig'.typescript.setup(make_config())
  end
  if require'lspconfig'.lua then
    local luadev = require("lua-dev").setup({
      lspconfig = {
        on_attach = on_attach_common,
      },
    })
    require'lspconfig'.lua.setup(luadev)
  end
  if require'lspconfig'.bash then
    require'lspconfig'.bash.setup(make_config())
  end
  if require'lspconfig'.angular then
    local configPath = vim.fn.stdpath("config")
    local languageServerPath = configPath.."/languageserver"
    -- local languageServerPath = "/home/jemag/.local/share/nvim/lspinstall/angular"
    local angular_cmd = {"node", languageServerPath.."/node_modules/@angular/language-server/index.js", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath}
    -- local angular_cmd = {"node", languageServerPath.."/node_modules/@angular/language-server/bin/ngserver", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath}
    -- local angular_cmd = {"node", languageServerPath.."/node_modules/@angular/language-server/bin/ngserver", "--stdio", "--tsProbeLocations", "/home/jemag/dev/typescript", "--ngProbeLocations", languageServerPath}
    -- local angular_cmd = {"/home/jemag/.local/share/nvim/lspinstall/angular/./node_modules/.bin/ngserver", "tsProbeLocations", "/home/jemag/dev/typescript"}
    -- local angular_cmd = {"at"}
    local angular_config= make_config()
    angular_config.cmd= angular_cmd
    angular_config.on_new_config = function(new_config,new_root_dir)
      new_config.cmd = angular_cmd
    end
    require'lspconfig'.angular.setup(angular_config)
  end
  if require'lspconfig'.terraform then
    require'lspconfig'.terraform.setup(make_config())
  end
  if require'lspconfig'.json then
    require'lspconfig'.json.setup(make_config())
  end
  if require'lspconfig'.cpp then
    require'lspconfig'.cpp.setup(make_config())
  end
  if require'lspconfig'.rust then
    require'lspconfig'.rust.setup(make_config())
  end
  if require'lspconfig'.vim then
    require'lspconfig'.vim.setup(make_config())
  end
  if require'lspconfig'.dockerfile then
    require'lspconfig'.dockerfile.setup(make_config())
  end
  if require'lspconfig'.html then
    require'lspconfig'.html.setup(make_config())
  end
  if require'lspconfig'.yaml then
    local yaml_config= make_config()
    yaml_config.filetypes = {'yaml'}
    require'lspconfig'.yaml.setup(make_config())
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

require'lspconfig'.gopls.setup{
  on_attach = on_attach_common,
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
  require('jdtls').setup_dap()
  require('jdtls').setup.add_commands()
  require'lsp_signature'.on_attach()
  set_lsp_icons()
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
  map('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n', '<leader>lN', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')

  map("n", "<leader>uo", "<Cmd>lua require'jdtls'.organize_imports()<CR>")
  map("n", "<leader>ut", "<Cmd>lua require'jdtls'.test_class({ config = { console = 'console' }})<CR>")
  map("n", "<leader>uT", "<Cmd>lua require'jdtls'.test_nearest_method({ config = { console = 'console' }})<CR>")
  map("v", "<leader>ue", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
  map("n", "<leader>ue", "<Cmd>lua require('jdtls').extract_variable()<CR>")
  map("v", "<leader>um", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")
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

local autocmds = {
  lsp = {
    {"FileType",     "java",   "lua Start_jdt()"};
    -- TODO: put in on_attach instead so that it doesn't happen for buffers without language server?
    {"CursorHold",     "*",   "lua vim.lsp.diagnostic.show_line_diagnostics()"};
  };
}
require'utils'.nvim_create_augroups(autocmds)
 
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.lsp.diagnostic.clear(0)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
  else
    vim.g.diagnostics_active = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = false,
        signs = true,
        update_in_insert = false,
      }
    )
  end
end

vim.api.nvim_set_keymap('n', '<leader>tx', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true})
