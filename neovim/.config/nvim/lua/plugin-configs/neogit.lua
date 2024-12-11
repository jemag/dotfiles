local neogit = require("neogit")

neogit.setup({
  auto_refresh = true,
  -- customize displayed signs
  integrations = {
    diffview = true,
    telescope = true
  },
  mappings = {
    popup = {
      ["g?"] = "HelpPopup",
      ["?"] = false,
    }
  }
})
vim.keymap.set("n", "<localleader>tn", "<cmd>Neogit<cr>", { desc = "Neogit" })
