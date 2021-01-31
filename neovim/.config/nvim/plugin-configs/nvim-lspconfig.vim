autocmd CursorHold * silent lua vim.lsp.diagnostic.show_line_diagnostics()
lua <<EOF
-- highlights for vim illuminate
local home = os.getenv('HOME')
vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
vim.api.nvim_command [[ hi def link illuminatedCurWord CursorLine ]]

-- util function to map keys
local map = function(type, key, value)
    vim.fn.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

-- GOTO mappings
local map_keys = function()
  map('n', '<leader>lD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', '<leader>ld','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', '<C-q>','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lh','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>lr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '<leader>ls','<cmd>lua vim.lsp.buf.signature_help()<CR>')
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
-- configuring diagnostics
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsDefaultError", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsDefaultWarning", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "🛈", texthl = "LspDiagnosticsDefaultInformation", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "!", texthl = "LspDiagnosticsDefaultHint", numhl = "LspDiagnosticsDefaultHint"})

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
  }
)

local configPath = vim.fn.stdpath("config")
local languageServerPath = configPath.."/languageserver"
vim.lsp.set_log_level(0)

-- common attach config
local on_attach_common = function(client)
    print("lsp started")
    require'completion'.on_attach(client)
    require'illuminate'.on_attach(client)
    map_keys()
end


require'lspconfig'.tsserver.setup{
  on_attach = on_attach_common,
  cmd = {languageServerPath.."/node_modules/typescript-language-server/lib/cli.js", "--stdio"}
}

local angular_cmd = {"node", languageServerPath.."/node_modules/@angular/language-server/index.js", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath}
require'lspconfig'.angularls.setup{
  on_attach = on_attach_common,
  cmd = angular_cmd,
  on_new_config = function(new_config,new_root_dir)
  new_config.cmd = angular_cmd
  end,
}

require'lspconfig'.bashls.setup{
  on_attach = on_attach_common
}

require'lspconfig'.terraformls.setup{
  on_attach = function(client)
  require'completion'.on_attach(client)
  map_keys()
  print("lsp started")
  end,
}

if require'lspconfig'.jsonls then
require'lspconfig'.jsonls.setup{
  on_attach = function(client)
  print("lsp started")
  require'completion'.on_attach(client)
  map_keys()
  end,
  cmd = {languageServerPath.."/node_modules/vscode-json-languageserver/bin/vscode-json-languageserver", "--stdio"}
}
end

require'lspconfig'.gopls.setup{
  on_attach = on_attach_common
}

require'lspconfig'.clangd.setup{
  on_attach = on_attach_common
}

require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach_common
}

require'lspconfig'.vimls.setup{
  on_attach = on_attach_common,
  cmd = {languageServerPath.."/node_modules/vim-language-server/bin/index.js", "--stdio"}
  }


require'lspconfig'.dockerls.setup{
  on_attach = on_attach_common,
  cmd = {languageServerPath.."/node_modules/dockerfile-language-server-nodejs/bin/docker-langserver", "--stdio"}

}

require'lspconfig'.html.setup{
  on_attach = on_attach_common,
  cmd = {languageServerPath.."/node_modules/vscode-html-languageserver-bin/htmlServerMain.js", "--stdio"}
}

require'lspconfig'.yamlls.setup{
  on_attach = function(client)
  print("lsp started")
  require'completion'.on_attach(client)
  map_keys()
  end,
  cmd = {languageServerPath.."/node_modules/yaml-language-server/bin/yaml-language-server", "--stdio"}
}


-- require'lspconfig'.jdtls.setup{ on_attach=require'completion'.on_attach }
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

local on_attach_java = function(client)
    require'illuminate'.on_attach(client)
    require'completion'.on_attach(client)
    require('jdtls').setup_dap()
    require('jdtls').setup.add_commands()
    map('n', '<leader>lD','<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', '<leader>ld','<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', '<C-q>','<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', '<leader>lh','<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', '<leader>lr','<cmd>lua vim.lsp.buf.references()<CR>')
    map('n', '<leader>ls','<cmd>lua vim.lsp.buf.signature_help()<CR>')
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

    map("n", "<leader>uo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
    map("n", "<leader>ut", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
    map("n", "<leader>uT", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
    map("v", "<leader>ue", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
    map("n", "<leader>ue", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
    map("v", "<leader>um", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
end

local dap = require('dap')

dap.defaults.fallback.external_terminal = {
  command = '/usr/bin/alacritty';
  args = {'-e'};
}

local bundles= {vim.fn.glob("/home/jemag/dev/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
}
vim.list_extend(bundles, vim.split(vim.fn.glob("/home/jemag/dev/vscode-java-test/server/*.jar"), "\n"))

--TODO: could potentially want GUID for project directory to avoid problems with project with similar names or opening twice the same project?!
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

function start_jdt()
    print("starting jdt")
    require('jdtls').start_or_attach({
    cmd = {'java-lsp.sh', workspace_folder},
    init_options = {
      bundles = bundles,
    },
    on_attach = function(client)
    --on_attach_common(client)
    on_attach_java(client)
    end
    })

end;

local autocmds = {
	lsp = {
		{"FileType",     "java",   "lua start_jdt()"};
	};
}

--TODO: move to utils lua module
function nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command('augroup '..group_name)
		vim.api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			-- if type(def) == 'table' and type(def[#def]) == 'function' then
			--	def[#def] = lua_callback(def[#def])
			-- end
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command('augroup END')
	end
end

nvim_create_augroups(autocmds)

--TODO:  move to utils lua module
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = "/home/jemag/dev/sumneko/lua-language-server"
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
require'lspconfig'.sumneko_lua.setup{
  on_attach = on_attach_common,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = { "vim", "it", "describe" },
      },
    },
    runtime = {version = "LuaJIT"},
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  },
}
EOF
