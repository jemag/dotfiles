require("bqf").setup({
  preview = {
    auto_preview = false,
  },
  filter = {
    fzf = {
      extra_opts = { "--bind", "ctrl-e:toggle-all" },
    },
  },
})
