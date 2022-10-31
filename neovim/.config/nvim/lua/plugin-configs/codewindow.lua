local codewindow = require("codewindow")
codewindow.setup()
vim.keymap.set("n", "<localleader>tM", codewindow.toggle_minimap, { desc = "Toggle minimap"})
