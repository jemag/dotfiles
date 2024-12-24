require("spelunk").setup({
  enable_persist = true,
  base_mappings = {
    toggle = "<c-n>",
    next_bookmark = "]b",
    prev_bookmark = "[b",
  },
  window_mappings = {
    close = "<esc>",
  }
})
