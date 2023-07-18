local neogit = require("neogit")

neogit.setup({
  auto_refresh = true,
  -- customize displayed signs
  integrations = {
    diffview = true,
  },
})
vim.keymap.set("n", "<localleader>tn", "<cmd>Neogit<cr>", { desc = "Neogit" })
