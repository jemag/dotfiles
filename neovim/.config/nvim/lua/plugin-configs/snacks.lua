require("snacks").setup({
  bigfile = {
    enabled = true,
    size = 0.5 * 1024 * 1024, -- 0.5 MiB
  },
  notifier = {
    enabled = false,
  },
  quickfile = {
    enabled = false,
  },
  statuscolumn = {
    enabled = false,
  },
})
