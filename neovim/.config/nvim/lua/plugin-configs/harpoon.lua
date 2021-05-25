require("harpoon").setup({
  global_settings = {
    save_on_toggle = false,
    save_on_change = true,
  },
  projects = {
    -- Yes $HOME works
    ["$HOME/dotfiles"] = {
      term = {
        cmds = {
          "env"
        }
      }
    }
  }
})
