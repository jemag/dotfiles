require("buffer_manager").setup({
  select_menu_item_commands = {
    v = {
      key = "<C-v>",
      command = "vsplit",
    },
    h = {
      key = "<C-x>",
      command = "split",
    },
  },
})
vim.keymap.set("n", "<leader>bm", function()
  require("buffer_manager.ui").toggle_quick_menu()
end)

vim.api.nvim_create_augroup("buffer_manager", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "buffer_manager",
  callback = function()
    vim.keymap.set("n", "J", "<cmd>:m +1<CR>gv=gv", { buffer = true })
    vim.keymap.set("n", "K", "<cmd>:m -2<CR>gv=gv", { buffer = true })
    -- vim.keymap.set("n", "<C-v>", function()
    --   local picked_window_id = require("window-picker").pick_window()
    --   vim.api.nvim_set_current_win(picked_window_id)
    --   vim.cmd("vsplit")
    -- end, { buffer = true })
    -- vim.keymap.set("n", "<C-x>", function()
    --   local picked_window_id = require("window-picker").pick_window()
    --   vim.api.nvim_set_current_win(picked_window_id)
    --   vim.cmd("split")
    -- end, { buffer = true })
  end,
  group = "buffer_manager",
  desc = "Set buffer_manager keybinds",
})
