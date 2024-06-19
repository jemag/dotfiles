require("trouble").setup({
  autojump = false,
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
  },
})
vim.keymap.set("n", "<localleader>ttd", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
vim.keymap.set("n", "<localleader>tts", "<cmd>Trouble symbols toggle<cr>", { desc = "Trouble symbols" })
