vim.keymap.set({ "n", "x" }, "*", "<Plug>(asterisk-*)", { desc = "Asterisk *" })
vim.keymap.set({ "n", "x" }, "#", "<Plug>(asterisk-#)", { desc = "Asterisk #" })
vim.keymap.set({ "n", "x" }, "g*", "<Plug>(asterisk-g*)", { desc = "Asterisk g*" })
vim.keymap.set({ "n", "x" }, "g#", "<Plug>(asterisk-g#)", { desc = "Asterisk g#" })
vim.keymap.set({ "n", "x" }, "z*", "<Plug>(asterisk-z*)", { desc = "Asterisk z*" })
vim.keymap.set({ "n", "x" }, "gz*", "<Plug>(asterisk-gz*)", { desc = "Asterisk gz*" })
vim.keymap.set({ "n", "x" }, "z#", "<Plug>(asterisk-z#)", { desc = "Asterisk z#" })
vim.keymap.set({ "n", "x" }, "gz#", "<Plug>(asterisk-gz#)", { desc = "Asterisk gz#" })

vim.g["asterisk#keeppos"] = true
