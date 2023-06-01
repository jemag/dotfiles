require("scrollview").setup({
  -- excluded_filetypes = {'nerdtree'},
  current_only = false,
  winblend = 50,
  base = "right",
  signs_on_startup = {
    "conflicts",
    "cursor",
    "diagnostics",
    "marks",
    "search",
    "spell",
    "textwidth",
    "trail",
  },
})
