require("scrollview").setup({
  -- excluded_filetypes = {'nerdtree'},
  current_only = false,
  winblend = 30,
  winblend_gui = 30,
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

vim.keymap.set({ "n", "x" }, "]v", "<cmd>ScrollViewNext<cr>", { desc = "Go to next scroll sign" })
vim.keymap.set({ "n", "x" }, "[v", "<cmd>ScrollViewPrev<cr>", { desc = "Go to prev scroll sign" })
