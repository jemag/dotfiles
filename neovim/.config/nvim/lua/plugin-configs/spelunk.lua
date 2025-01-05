require("spelunk").setup({
  enable_persist = true,
  statusline_prefix = "",
  base_mappings = {
    toggle = "<c-n>",
    next_bookmark = "]b",
    prev_bookmark = "[b",
  },
  window_mappings = {
    close = "<esc>",
  }
})
