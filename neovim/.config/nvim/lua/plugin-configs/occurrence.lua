require("occurrence").setup({
  -- Whether to include default keymaps.
  --
  -- If `false`, global keymaps, such as the default `go` to activate
  -- occurrence mode, or the default `o` to modify a pending operator,
  -- are not set, so activation keymaps must be set manually,
  -- e.g., `vim.keymap.set("n", "<leader>o", "<Plug>(OccurrenceMark)")``
  -- or `vim.keymap.set("o", "<C-o>", "<Plug>(OccurrenceModifyOperator)")`.
  --
  -- Additionally, when `false`, only keymaps explicitly defined in `keymaps`
  -- will be automatically set when activating occurrence mode. Keymaps for
  -- occurrence mode can also be set manually in an `OccurrenceActivate`
  -- autocmd using `occurrence.keymap:set(...)`.
  --
  -- Default `operators` will still be set unless `default_operators` is also `false`.
  --
  -- Defaults to `true`.
  default_keymaps = true,

  -- Whether to include default operator support.
  -- (c, d, y, p, gp, <, >, =, gu, gU, g~)
  --
  -- If `false`, only operators explicitly defined in `operators`
  -- will be supported.
  --
  -- Defaults to `true`.
  default_operators = true,

  -- A table defining keymaps that will be active in occurrence mode.
  -- Each key is a string representing the keymap, and each value is either:
  --   - a string representing the name of a built-in API action,
  --   - a table defining a custom keymap configuration,
  --   - or `false` to disable the keymap.
  keymaps = {
    ["n"] = "next", -- Next marked occurrence
    ["N"] = "previous", -- Previous marked occurrence
    ["gn"] = "match_next", -- Next occurrence (all matches)
    ["gN"] = "match_previous", -- Previous occurrence (all matches)
    ["go"] = "toggle", -- Toggle or mark an occurrence
    ["ga"] = "mark", -- Mark current occurrence
    ["gx"] = "unmark", -- Unmark current occurrence
    ["<Esc>"] = "deactivate", -- Exit occurrence mode
    ["<C-c>"] = "deactivate", -- Exit occurrence mode
    ["<C-[>"] = "deactivate", -- Exit occurrence mode
  },

  -- A table defining operators that can be modified to operate on occurrences.
  -- These operators will also be active as keymaps in occurrence mode.
  -- Each key is a string representing either the operator key or
  -- a custom operator name, and each value is either:
  --   - a string representing the name of a builtin or custom operator,
  --   - a table defining a custom operator configuration,
  --   - or `false` to disable the operator.
  operators = {
    ["c"] = "change", -- Change marked occurrences
    ["d"] = "delete", -- Delete marked occurrences
    ["y"] = "yank", -- Yank marked occurrences
    ["p"] = "put", -- Put register at marked occurrences
    ["gp"] = "distribute", -- Distribute lines from register across occurrences
    ["<"] = "indent_left", -- Indent left
    [">"] = "indent_right", -- Indent right
    ["="] = "indent_format", -- Indent/format
    ["gu"] = "lowercase", -- Convert to lowercase
    ["gU"] = "uppercase", -- Convert to uppercase
    ["g~"] = "swap_case", -- Swap case
  },
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "OccurrenceMatch", { fg = "#000000", bg = "#F29E74" })
    vim.api.nvim_set_hl(0, "OccurrenceMark", { bold = true, italic = false })
    vim.api.nvim_set_hl(0, "OccurrenceCurrent", { italic = true })
  end,
})
