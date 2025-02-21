require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
  },
})

  vim.keymap.set({"i", "n", "x"}, "<F10>", "<Cmd>CodeCompanionChat toggle<CR>", { desc = "Toggle CodeCompanionChat"})
  vim.keymap.set({"n", "x"}, "<leader>aa", "<Cmd>CodeCompanionActions <CR>", { desc = "Toggle CodeCompanionActions"})
