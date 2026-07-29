require("codediff").setup({
  explorer = {
    width = 50,
    view_mode = "tree",
  },
  diff = {
    compact = true, -- fold unchanged regions by default; toggle with gc
    compact_context_lines = 5,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Relative line numbers for vscode-diff-explorer",
  pattern = { "codediff-explorer" },
  callback = function()
    vim.schedule(function()
      vim.wo.relativenumber = true
    end)
  end,
})
