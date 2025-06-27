require("nvim-surround").setup({
  keymaps = { -- vim-surround style keymaps
    insert = "<C-g>s",
    insert_line = "<C-g>S",
    normal = "ys",
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",
    change = "cs",
  },
  surrounds = {
    ["C"] = {
      add = function()
        local config = require("nvim-surround.config")
        local result = config.get_input("Custom pattern: ")
        return {
          { result },
          { result },
        }
      end,
    },
  },
  highlight = { -- Highlight text-objects before surrounding them
    duration = 0,
  },
})
