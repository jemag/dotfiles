require("snacks").setup({
  styles = {
    notification_history = {
      relative = "editor",
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
      relative = "editor",
      wo = {
        wrap = true,
      },
    },
  },
  bigfile = {
    enabled = true,
    size = 0.3 * 1024 * 1024, -- 0.3 MiB
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
  words = {
    enabled = true,
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
vim.keymap.set({ "n", "x", "t" }, "]w", function()
  require("snacks").words.jump(vim.v.count1)
end, { desc = "Jump to next word reference" })
vim.keymap.set({ "n", "x", "t" }, "[w", function()
  require("snacks").words.jump(-vim.v.count1)
end, { desc = "Jump to prev word reference" })
