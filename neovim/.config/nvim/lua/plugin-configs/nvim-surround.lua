-- Disable default mappings (v4 migration)
vim.g.nvim_surround_no_insert_mappings = true
vim.g.nvim_surround_no_normal_mappings = true
vim.g.nvim_surround_no_visual_mappings = true

require("nvim-surround").setup({
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

-- vim-surround style keymaps (v4 format using <Plug> mappings)
-- Insert mode
vim.keymap.set("i", "<C-g>s", "<Plug>(nvim-surround-insert)", {
  desc = "Add a surrounding pair around the cursor (insert mode)",
})
vim.keymap.set("i", "<C-g>S", "<Plug>(nvim-surround-insert-line)", {
  desc = "Add a surrounding pair around the cursor on new lines (insert mode)",
})

-- Normal mode
vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {
  desc = "Add a surrounding pair around a motion",
})
vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)", {
  desc = "Add a surrounding pair around the current line",
})
vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal-line)", {
  desc = "Add a surrounding pair around a motion on new lines",
})
vim.keymap.set("n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", {
  desc = "Add a surrounding pair around the current line on new lines",
})
vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {
  desc = "Delete a surrounding pair",
})
vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {
  desc = "Change a surrounding pair",
})

-- Visual mode
vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual)", {
  desc = "Add a surrounding pair around a visual selection",
})
vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
  desc = "Add a surrounding pair around a visual selection on new lines",
})
