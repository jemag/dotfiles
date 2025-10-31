vim.keymap.set({ "n", "x" }, "<C-a>", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })

vim.keymap.set({ "n", "x" }, "<leader>ao", function()
  require("opencode").select()
end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "x" }, "<leader>aO", function()
  require("opencode").prompt("@this")
end, { desc = "Add to opencode" })

vim.keymap.set({"n", "x", "t", "i"}, "<F11>", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })

vim.keymap.set("n", "<C-u>", function()
  require("opencode").command("messages_half_page_up")
end, { desc = "opencode half page up" })

vim.keymap.set("n", "<C-d>", function()
  require("opencode").command("messages_half_page_down")
end, { desc = "opencode half page down" })
-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
