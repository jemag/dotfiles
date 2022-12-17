local gopher_keybinds = vim.api.nvim_create_augroup("GopherKeybinds", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>ut", "<cmd>GoMod tidy<cr>", { buffer = true, desc = "Tidy" })
    vim.keymap.set("n", "<leader>ua", "<cmd>GoTestAdd<Cr>", { buffer = true, desc = "Add Test" })
    vim.keymap.set("n", "<leader>uA", "<cmd>GoTestsAll<Cr>", { buffer = true, desc = "Add All Tests" })
    vim.keymap.set("n", "<leader>ue", "<cmd>GoIfErr<Cr>", { buffer = true, desc = "Generate if err" })
    vim.keymap.set("n", "<leader>uE", "<cmd>GoTestsExp<Cr>", { buffer = true, desc = "Add Exported Tests" })
    vim.keymap.set("n", "<leader>ug", "<cmd>GoGenerate<Cr>", { buffer = true, desc = "Go Generate" })
    vim.keymap.set("n", "<leader>uf", "<cmd>GoGenerate %<Cr>", { buffer = true, desc = "Go Generate File" })
    vim.keymap.set("n", "<leader>uT", "<cmd>lua require('dap-go').debug_test()<cr>",
      { buffer = true, desc = "Debug Test" })
  end,
  group = gopher_keybinds,
})
