require("mini.operators").setup({
  -- Evaluate text and replace with output
  evaluate = {
    prefix = "g=",
  },

  -- Exchange text regions
  exchange = {
    prefix = "gx",
  },

  -- Multiply (duplicate) text
  multiply = {
    prefix = "",
  },

  -- Replace text with register
  replace = {
    prefix = "s",
  },

  -- Sort text
  sort = {
    prefix = "gs",
  },
})
vim.keymap.set({ "n" }, "gX", "gx$", { remap = true, desc = "Exchange until end of line" })
vim.keymap.set({ "n" }, "gS", "gs$", { remap = true, desc = "Sort until end of line" })
