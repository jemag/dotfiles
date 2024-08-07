require("kubectl").setup({
  auto_refresh = {
    enabled = true,
    interval = 5000, -- milliseconds
  },
  diff = {
    bin = "kubediff" -- or any other binary
  },
  namespace = "All",
  notifications = {
    enabled = true,
    verbose = false,
    blend = 100,
  },
  hints = true,
  context = true,
  float_size = {
    -- Almost fullscreen:
    -- width = 1.0,
    -- height = 0.95, -- Setting it to 1 will cause bottom to be cutoff by statuscolumn

    -- For more context aware size:
    width = 0.9,
    height = 0.85,

    -- Might need to tweak these to get it centered when float is smaller
    col = 5,
    row = 5,
  },
  obj_fresh = 0, -- highlight if creation newer than number (in minutes)
  mappings = {
    exit = "<leader>kt",
  }
})
-- Recommended is to have the same open mapping as your close (```<leader>k```) the plugin for a toggle effect.
vim.keymap.set("n", "<leader>kt", '<cmd>lua require("kubectl").open()<cr>', { noremap = true, silent = true , desc = "Toggle kubectl.nvim"})

