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

  vim.keymap.set({"i", "n"}, "<F10>", "<Cmd>CodeCompanionChat toggle<CR>", { desc = "Toggle CodeCompanionChat"})
