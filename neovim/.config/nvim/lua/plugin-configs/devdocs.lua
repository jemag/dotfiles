require("devdocs").setup({
  ensure_installed = {
    "kubectl",
    "terraform",
    "jq",
    "go",
    "html",
    "http",
    "lua~5.1",
    "nushell",
    "openjdk~21",
  }
})

vim.keymap.set({ "n"}, "<localleader>dg", "<cmd>DevDocs get<cr>", { desc = "Devdocs get" })
vim.keymap.set({ "n"}, "<localleader>di", "<cmd>DevDocs install<cr>", { desc = "Devdocs install" })
