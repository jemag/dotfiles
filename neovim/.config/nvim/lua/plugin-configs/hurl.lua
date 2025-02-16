require("hurl").setup({
  -- Show debugging info
  debug = false,
  -- Show notification on run
  show_notification = false,
  -- Show response in popup or split
  mode = "split",
  -- Default formatter
  formatters = {
    json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
    html = {
      "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
      "--parser",
      "html",
    },
    xml = {
      "tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
      "-xml",
      "-i",
      "-q",
    },
  },
  -- Default mappings for the response popup or split views
  mappings = {
    close = "q", -- Close the response popup or split view
    next_panel = "<C-n>", -- Move to the next response popup window
    prev_panel = "<C-p>", -- Move to the previous response popup window
  },
})
vim.keymap.set({ "n" }, "<localleader>hA", "<cmd>HurlRunner<CR>", { desc = "Run All requests" })
vim.keymap.set({ "n" }, "<localleader>ha", "<cmd>HurlRunnerAt<CR>", { desc = "Run Api request" })
vim.keymap.set({ "n" }, "<localleader>he", "<cmd>HurlRunnerToEntry<CR>", { desc = "Run Api request to entry" })
vim.keymap.set({ "n" }, "<localleader>hE", "<cmd>HurlRunnerToEnd<CR>", { desc = "Run Api request from current entry to end" })
vim.keymap.set({ "n" }, "<localleader>hm", "<cmd>HurlToggleMode<CR>", { desc = "Hurl Toggle Mode" })
vim.keymap.set({ "n" }, "<localleader>hM", "<cmd>HurlManageVariable<CR>", { desc = "Hurl Manage Variable" })
vim.keymap.set({ "n" }, "<localleader>hv", "<cmd>HurlVerbose<CR>", { desc = "Run Api in verbose mode" })
vim.keymap.set({ "n" }, "<localleader>hV", "<cmd>HurlVeryVerbose<CR>", { desc = "Run Api in very verbose mode" })
vim.keymap.set({ "v" }, "<localleader>hr", ":HurlRunner<CR>", { desc = "Hurl Runner" })
