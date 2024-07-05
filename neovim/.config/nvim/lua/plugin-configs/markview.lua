require("markview").setup({
    buf_ignore = { "nofile" },
    modes = { "n" },

    -- Returns the conceallevel to the global value when changing modes
    restore_conceallevel = true,
    -- Returns the concealcursor to the global value when changing modes
    restore_concealcursor = true,
});
vim.keymap.set("n", "<localleader>tmv", "<cmd>Markview<CR>", { desc = "Toggle markview"})
