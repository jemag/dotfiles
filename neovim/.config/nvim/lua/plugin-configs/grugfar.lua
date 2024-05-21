require("grug-far").setup({
  keymaps = {
    -- normal and insert mode
    replace = "<c-r>",
    qflist = "<C-q>",
    syncLocations = "<C-s>",
    syncLine = "<C-a>",
    close = "<C-x>",

    -- normal mode only
    gotoLocation = { n = "<enter>" },
  },
})
