require("nvim-surround").setup({
  keymaps = { -- vim-surround style keymaps
    insert = "ys",
    insert_line = "yss",
    visual = "S",
    delete = "ds",
    change = "cs",
  },
  highlight = { -- Highlight text-objects before surrounding them
    duration = 0,
  },
})
