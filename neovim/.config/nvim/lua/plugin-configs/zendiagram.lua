require("zendiagram").setup({
  border = "single",
})
vim.keymap.set({ "n", "x" }, "<c-w>d", function()
  require("zendiagram").open()
end, { desc = "Open diagnostic float" })

vim.keymap.set({ "n", "x" }, "]d", function()
  vim.diagnostic.jump({ count = 1 })
  vim.schedule(function()
    require("zendiagram").open()
  end)
end, { desc = "Jump to next diagnostic" })

vim.keymap.set({ "n", "x" }, "[d", function()
  vim.diagnostic.jump({ count = -1 })
  vim.schedule(function()
    require("zendiagram").open()
  end)
end, { desc = "Jump to prev diagnostic" })
