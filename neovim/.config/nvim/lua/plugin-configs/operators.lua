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
    prefix = "gm",
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
vim.keymap.set({ "n", "x" }, "<cr>s", '"+s', { remap = true, desc = "Substitute with +reg" })
vim.keymap.set({ "n", "x" }, "S", "s$", { remap = true, desc = "Substitute with +reg" })
vim.keymap.set("n", "<cr>ss", '"+ss', {
  remap = true,
  desc = "Substitute with +reg",
})
vim.keymap.set("n", "<cr>S", '"+s$', { remap = true, desc = "Substitute with +reg" })
