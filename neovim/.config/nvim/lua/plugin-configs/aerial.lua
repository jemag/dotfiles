require("aerial").setup({
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",

    "Field", -- For jsonnet
    "Variable", -- For jsonnet
  },
  layout = {
    min_width = 25,
    default_direction = "right",
  },
  on_attach = function(bufnr)
    -- Toggle the aerial window with <leader>a
    -- Jump forwards/backwards with '{' and '}'
    vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", { desc = "Aerial prev" })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", { desc = "Aerial prev" })
    -- Jump up the tree with '[[' or ']]'
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", ":lua require('aerial').prev_up()<CR>", { desc = "Aerial prev up" })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", ":lua require('aerial').next_up()<CR>", { desc = "Aerial next up" })
  end,
})
vim.keymap.set("n", "<localleader>ta", "<cmd>AerialToggle!<CR>", { desc = "Toggle aerial" })
