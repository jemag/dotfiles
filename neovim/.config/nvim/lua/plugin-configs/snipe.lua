require("snipe").setup({
  ui = { position = "center" },
})

vim.keymap.set({ "n", "x" }, "<c-n>", require("snipe").open_buffer_menu, { desc = "Snipe buffer menu" })
