require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },

    yaml = { "yamlfmt" },
    nix = { "nixfmt" },
    python = { "isort", "black" },
    lua = { "stylua" },
    sh = { "shfmt" },
  },
  formatters = {
    shfmt = {
      args = { "-i", "2" },
    },
  },
})
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.keymap.set({ "n", "x" }, "<leader>fb", "<cmd>Format<CR>", { desc = "Format" })
