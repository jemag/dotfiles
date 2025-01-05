require("snacks").setup({
  styles = {
    notification_history = {
      border = "rounded",
      zindex = 100,
      width = 0.95,
      height = 0.95,
      minimal = false,
      title = " Notification History ",
      title_pos = "center",
      ft = "markdown",
      bo = { filetype = "snacks_notif_history", modifiable = false },
      wo = { wrap = true, winhighlight = "Normal:SnacksNotifierHistory" },
      keys = { q = "close" },
    },
    notification = {
      wo = {
        wrap = true,
      },
    },
  },
  bigfile = {
    enabled = true,
    size = 0.5 * 1024 * 1024, -- 0.5 MiB
  },
  notifier = {
    enabled = true,
  },
  quickfile = {
    enabled = true,
  },
  statuscolumn = {
    enabled = false,
  },
  scratch = {
    ft = function()
      return "markdown"
    end,
  },
})

vim.keymap.set("n", "<localleader>ts", function()
  require("snacks").scratch()
end, { desc = "Toggle scratch buffer" })
vim.keymap.set("n", "<localleader>tS", function()
  require("snacks").scratch.select()
end, { desc = "Select scratch buffer" })
vim.keymap.set("n", "<localleader>tS", function()
  require("snacks").scratch.select()
end, { desc = "Select scratch buffer" })
vim.keymap.set("n", "<localleader>tN", require("snacks").notifier.hide, { desc = "Hide notifications" })
vim.keymap.set("n", "<localleader>th", require("snacks").notifier.show_history, { desc = "Notifications history" })
