local M = {}
local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local signature_cfg = {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
  -- set to 0 if you DO NOT want any API comments be shown
  -- This setting only take effect in insert mode, it does not affect signature help in normal
  -- mode, 10 by default

  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
  hint_enable = false, -- virtual hint enable
  hint_prefix = "🐼 ", -- Panda for parameter
  hint_scheme = "String",
  use_lspsaga = false, -- set to true if you want to use lspsaga popup
  hi_parameter = "Search", -- how your parameter will be highlight
  max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
  -- to view the hiding contents
  max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "single", -- double, single, shadow, none
  },
  -- deprecate !!
  -- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
}

local function map_keys(bufnr)
  local opts = { noremap = true, silent = true }
  local bufmap = vim.api.nvim_buf_set_keymap
  bufmap(bufnr, "n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  bufmap(bufnr, "n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  bufmap(bufnr, "n", "<C-q>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  bufmap(bufnr, "n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  bufmap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  bufmap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  bufmap(bufnr, "i", "<C-q>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  bufmap(bufnr, "n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  bufmap(bufnr, "n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  bufmap(bufnr, "n", "<leader>lw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
  bufmap(bufnr, "n", "<leader>lW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
  bufmap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  bufmap(bufnr, "n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  bufmap(bufnr, "n", "<leader>ll", '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
  bufmap(bufnr, "n", "<leader>lc", '<cmd>lua vim.diagnostic.open_float(0, {scope="cursor"})<CR>', opts)
  bufmap(bufnr, "n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next{float=false}<CR>", opts)
  bufmap(bufnr, "n", "<leader>lN", "<cmd>lua vim.diagnostic.goto_prev{float=false}<CR>", opts)
  bufmap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
  bufmap(bufnr, "n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", opts)
  bufmap(bufnr, "n", "<leader>de", "<cmd>lua require('dap.ui.widgets').hover()<CR>", opts)
  bufmap(bufnr, "n", "<leader>dE", "<cmd>lua require('dapui').eval()<CR>", opts)
  bufmap(
    bufnr,
    "n",
    "<leader>dv",
    "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
    opts
  )
  bufmap(bufnr, "n", "<leader>dso", "<cmd>lua require'dap'.step_over()<CR>", opts)
  bufmap(bufnr, "n", "<leader>dsi", "<cmd>lua require'dap'.step_into()<CR>", opts)
  bufmap(bufnr, "n", "<leader>dsO", "<cmd>lua require'dap'.step_out()<CR>", opts)
  bufmap(bufnr, "n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
  bufmap(bufnr, "n", "<leader>dtc", "<cmd>Telescope dap commands<CR>", opts)
  bufmap(bufnr, "n", "<leader>dtC", "<cmd>Telescope dap configurations<CR>", opts)
  bufmap(bufnr, "n", "<leader>dtf", "<cmd>Telescope dap frames<CR>", opts)
  bufmap(bufnr, "n", "<leader>dtl", "<cmd>Telescope dap list_breakpoints<CR>", opts)
  bufmap(bufnr, "n", "<leader>dtv", "<cmd>Telescope dap variables<CR>", opts)
  bufmap(
    bufnr,
    "n",
    "<leader>dB",
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    opts
  )
  bufmap(
    bufnr,
    "n",
    "<leader>dp",
    "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    opts
  )
  bufmap(bufnr, "n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", opts)
  bufmap(bufnr, "n", "<leader>dl", "<cmd>lua require'dap'.repl.run_last()<CR>", opts)
end

local function map_java_keys(bufnr)
  local opts = { noremap = true, silent = true }
  local bufmap = vim.api.nvim_buf_set_keymap
  bufmap(bufnr, "n", "<leader>uo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
  bufmap(bufnr, "n", "<leader>ut", "<Cmd>lua require'jdtls'.test_class({ config = { console = 'console' }})<CR>", opts)
  bufmap(
    bufnr,
    "n",
    "<leader>uT",
    "<Cmd>lua require'jdtls'.test_nearest_method({ config = { console = 'console' }})<CR>",
    opts
  )
  bufmap(bufnr, "v", "<leader>ue", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
  bufmap(bufnr, "n", "<leader>ue", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
  bufmap(bufnr, "v", "<leader>um", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
end

local function set_document_higlighting(client)
  local dfp = client.server_capabilities.documentFormattingProvider
  if vim.fn.empty(dfp) == 0 then
    require("illuminate").on_attach(client)
  end
end

local function set_signature_helper(client, bufnr)
  local shp = client.server_capabilities.signatureHelpProvider
  if vim.fn.empty(shp) == 0 then
    require("lsp_signature").on_attach(signature_cfg, bufnr)
  end
end

local function set_hover_border(client)
  local hp = client.server_capabilities.hoverProvider
  if vim.fn.empty(hp) == 0 then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  end
end

M.on_attach = function(client, bufnr)
  print(client.name .. " started")

  set_document_higlighting(client)
  set_signature_helper(client, bufnr)
  set_hover_border(client)
  map_keys(bufnr)
  if client.name == "jdt.ls" then
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls").setup.add_commands()
    -- Auto-detect main and setup dap config
    require("jdtls.dap").setup_dap_main_class_configs()
    map_java_keys(bufnr)
  end
  if client.name == "ansiblels" then
    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
      vim.diagnostic.disable(bufnr)
      vim.defer_fn(function()
        vim.diagnostic.reset(nil, bufnr)
      end, 1000)
    end
  end
  if client.name == "yamlls" then
    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
      vim.diagnostic.disable(bufnr)
      vim.defer_fn(function()
        vim.diagnostic.reset(nil, bufnr)
      end, 1000)
    end
  end
end

local function get_basic_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return capabilities
end

M.capabilities = require("cmp_nvim_lsp").update_capabilities(get_basic_capabilities())

return M
