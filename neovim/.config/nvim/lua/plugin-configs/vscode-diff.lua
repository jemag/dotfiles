require("vscode-diff").setup({
  explorer = {
    width = 50,
    view_mode = "tree",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Relative line numbers for vscode-diff-explorer",
  pattern = { "vscode-diff-explorer" },
  callback = function()
    vim.schedule(function()
      vim.wo.relativenumber = true
    end)
  end,
})
