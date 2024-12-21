require("snacks").setup({
  bigfile = {
    enabled = true,
    size = 0.5 * 1024 * 1024, -- 0.5 MiB
  },
  notifier = {
    enabled = false,
  },
  quickfile = {
    enabled = false,
  },
  statuscolumn = {
    enabled = false,
  },
  scratch = {
    ft = function()
      return "markdown"
    end
  },
})

vim.keymap.set("n", "<localleader>ts", function() require('snacks').scratch() end, { desc = "Toggle scratch buffer" })
vim.keymap.set("n", "<localleader>tS", function() require('snacks').scratch.select() end, { desc = "Select scratch buffer" })
