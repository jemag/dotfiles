vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
local function map_java_keys(bufnr)
  vim.keymap.set("n", "<leader>uo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organized imports", buffer = bufnr })
  vim.keymap.set(
    "n",
    "<leader>ut",
    "<Cmd>lua require'jdtls'.test_class({ config = { console = 'console' }})<CR>",
    { desc = "Test class", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "<leader>uT",
    "<Cmd>lua require'jdtls'.test_nearest_method({ config = { console = 'console' }})<CR>",
    { desc = "Test method", buffer = bufnr }
  )
  vim.keymap.set(
    "x",
    "<leader>ue",
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    { desc = "Extract variable", buffer = bufnr }
  )
  vim.keymap.set("n", "<leader>ue", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract variable", buffer = bufnr })
  vim.keymap.set("x", "<leader>um", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = "Extract method", buffer = bufnr })
end
map_java_keys(0)
