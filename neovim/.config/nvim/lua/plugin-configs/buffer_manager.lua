 require("buffer_manager").setup({
  select_menu_item_commands = {
    v = {
      key = "<C-v>",
      command = "vsplit"
    },
    h = {
      key = "<C-x>",
      command = "split"
    }
  }
})
vim.keymap.set("n", "<leader>bm", function() require("buffer_manager.ui").toggle_quick_menu() end)
