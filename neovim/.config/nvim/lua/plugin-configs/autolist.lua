local function set_autolist_keymap()
  print("setting autlist keymap")
  vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>", { buffer = true })
  vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>", { buffer = true })
  vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", { buffer = true })
  vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>", { buffer = true })
  vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", { buffer = true })
  vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>", { buffer = true })
  vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>", { buffer = true })

  -- cycle list types with dot-repeat
  vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true, buffer = true })
  vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true, buffer = true })

  -- if you don't want dot-repeat
  -- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
  -- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

  -- functions to recalculate list on edit
  vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>", { buffer = true })
  vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>", { buffer = true })
  vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>", { buffer = true })
  vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>", { buffer = true })
end

require("autolist").setup()
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "text", "tex", "plaintex", "norg" },
  callback = function()
    set_autolist_keymap()
  end,
  desc = "Set autolist buffer keymaps",
})
