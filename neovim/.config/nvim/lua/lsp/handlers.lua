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

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
    if result == nil or vim.tbl_isempty(result) then
      return nil
    end
    vim.lsp.util.preview_location(result[1])
  end)
end

local function map_keys(client, bufnr)
  -- local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Declaration", buffer = bufnr })
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Definition", buffer = bufnr })
  vim.keymap.set("n", "K", function()vim.lsp.buf.hover({border = "single"}) end, { desc = "Hover", buffer = bufnr })
  vim.keymap.set("n", "<leader>lp", peek_definition, { desc = "Peek definition", buffer = bufnr })
  vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "References", buffer = bufnr })
  vim.keymap.set("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help", buffer = bufnr })
  vim.keymap.set("i", "<C-q>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help", buffer = bufnr, silent = true })
  vim.keymap.set("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Implementation", buffer = bufnr })
  vim.keymap.set("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Type definition", buffer = bufnr })
  vim.keymap.set("n", "<leader>lw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { desc = "Document Symbol", buffer = bufnr })
  vim.keymap.set("n", "<leader>lW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { desc = "Workspace symbol", buffer = bufnr })
  vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code action", buffer = bufnr })
  vim.keymap.set("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename", buffer = bufnr })
  -- Default keybindg to show diagnostics is now <c-w>d
  vim.keymap.set(
    "n",
    "<leader>lc",
    '<cmd>lua vim.diagnostic.open_float(0, {scope="cursor"})<CR>',
    { desc = "Cursor diagnostics", buffer = bufnr }
  )

  vim.keymap.set("n", "\\I", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  end, { desc = "Toggle inlay hints", silent = true })
  vim.keymap.set("n", "<leader>lq", "<cmd>lua vim.diagnostic.setqflist()<CR>", { desc = "Diagnostic to quickfix", buffer = bufnr })
  vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue", buffer = bufnr })
  vim.keymap.set("n", "<leader>de", "<cmd>lua require('dap.ui.widgets').hover()<CR>", { desc = "Eval expression", buffer = bufnr })
  vim.keymap.set("n", "<leader>dE", "<cmd>lua require('dapui').eval()<CR>", { desc = "Dap ui eval", buffer = bufnr })
  vim.keymap.set("n", "<leader>dT", "<cmd>lua require('dapui').toggle({reset = true})<CR>", { desc = "Toggle dap ui", buffer = bufnr })
  vim.keymap.set(
    "n",
    "<leader>dv",
    "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
    { desc = "Scope variables widget", buffer = bufnr }
  )
  vim.keymap.set("n", "<leader>dso", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over", buffer = bufnr })
  vim.keymap.set("n", "<leader>dsi", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into", buffer = bufnr })
  vim.keymap.set("n", "<leader>dsO", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out", buffer = bufnr })
  vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint", buffer = bufnr })
  vim.keymap.set("n", "<leader>dtc", "<cmd>Telescope dap commands<CR>", { desc = "Dap commands", buffer = bufnr })
  vim.keymap.set("n", "<leader>dtC", "<cmd>Telescope dap configurations<CR>", { desc = "Dap configurations", buffer = bufnr })
  vim.keymap.set("n", "<leader>dtf", "<cmd>Telescope dap frames<CR>", { desc = "Dap frames", buffer = bufnr })
  vim.keymap.set("n", "<leader>dtl", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "List breakpoints", buffer = bufnr })
  vim.keymap.set("n", "<leader>dtv", "<cmd>Telescope dap variables<CR>", { desc = "Dap variables", buffer = bufnr })
  vim.keymap.set(
    "n",
    "<leader>dB",
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "Conditional breakpoint", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "<leader>dp",
    "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { desc = "Breakpoint with log", buffer = bufnr }
  )
  vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle repl", buffer = bufnr })
  vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.repl.run_last()<CR>", { desc = "Repl run last", buffer = bufnr })
end

local function set_hover_border(client)
  local hp = client.server_capabilities.hoverProvider
  if vim.fn.empty(hp) == 0 then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  end
end

M.on_attach = function(client, bufnr)
  set_hover_border(client)
  map_keys(client, bufnr)
  if client.name == "jdtls" then
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls").setup.add_commands()
    -- Auto-detect main and setup dap config
    require("jdtls.dap").setup_dap_main_class_configs()
  end
  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local function getCapabilities()
  local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
  --NOTE: Disabled dynamicRegistration for better performance, see: https://github.com/neovim/neovim/issues/23291
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  return capabilities
end

M.capabilities = getCapabilities()

return M
