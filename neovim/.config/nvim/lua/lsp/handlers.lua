local M = {}
local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

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
  bufmap(bufnr, "n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", opts)
  bufmap(bufnr, "n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", opts)
  bufmap(bufnr, "n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", opts)
  bufmap(bufnr, "n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", opts)
  bufmap(bufnr, "n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
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
  bufmap(bufnr, "n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", opts)
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
  if client.resolved_capabilities.document_highlight then
    require("illuminate").on_attach(client)
  end
end

local function set_signature_helper(client)
  if client.resolved_capabilities.signature_help then
    require("lsp_signature").on_attach({
      bind = true,
      handler_opts = {
        border = "single",
      },
    })
  end
end

local function set_hover_border(client)
  if client.resolved_capabilities.hover then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  end
end

M.on_attach = function(client, bufnr)
  print(client.name .. " started")

  set_document_higlighting(client)
  set_signature_helper(client)
  set_hover_border(client)
  map_keys(bufnr)
  if client.name == "jdt.ls" then
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls").setup.add_commands()
    map_java_keys(bufnr)
  end
end

local function get_basic_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

M.capabilities = require("cmp_nvim_lsp").update_capabilities(get_basic_capabilities())

return M
