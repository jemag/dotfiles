local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
-- local code_actions = null_ls.builtins.code_actons

-- https://github.com/prettier-solidity/prettier-plugin-solidity
-- npm install --save-dev prettier prettier-plugin-solidity
-- or make prettier command available in path (installed through pacman)
null_ls.setup({
  debug = true,
  sources = {
    formatting.prettierd.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "yaml",
        "markdown",
        "graphql",
        "solidity",
      },
    }),
    formatting.nixfmt,
    formatting.black.with({ extra_args = { "--fast" } }),
    -- stylua cmd must be in path (can install through pacman)
    formatting.stylua,
    formatting.shfmt.with({extra_args = { "-i", "2"}}),
    diagnostics.editorconfig_checker,
    diagnostics.yamllint,
  },
})
