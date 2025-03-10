require("mini.operators").setup({
  -- Evaluate text and replace with output
  evaluate = {
    prefix = "g=",
  },

  -- Exchange text regions
  exchange = {
    prefix = "cx",
  },

  -- Multiply (duplicate) text
  multiply = {
    prefix = "",
  },

  -- Replace text with register
  replace = {
    prefix = "",
  },

  -- Sort text
  sort = {
    prefix = "",
  },
})
vim.keymap.set({ "n" }, "cX", "cx$", { remap = true, desc = "Exchange until end of line" })
-- vim.keymap.set({ "n" }, "gS", "gs$", { remap = true, desc = "Sort until end of line" })
