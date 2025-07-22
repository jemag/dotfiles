require("mcphub").setup({
  use_bundled_binary = true, -- Use local `mcp-hub` binary
})
vim.keymap.set("n", "<localleader>tH", "<cmd>MCPHub<cr>", { desc = "McpHub" })
