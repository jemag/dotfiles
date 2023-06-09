require("gitsigns").setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
})
vim.keymap.set("n", "<leader>ha", '<cmd>Gitsigns attach<CR>', { desc = "Gitsigns attach" })
vim.keymap.set("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', { desc = "blame line" })
vim.keymap.set("n", "<leader>hc", '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = "toggle current line blame" })
vim.keymap.set("n", "<leader>hl", '<cmd>Gitsigns toggle_linehl<CR>', { desc = "toggle line hl" })
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "next hunk" })
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "prev hunk" })
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "preview hunk" })
vim.keymap.set({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
vim.keymap.set("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "reset buffer" })
vim.keymap.set({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "stage hunk" })
vim.keymap.set("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "stage buffer" })
vim.keymap.set("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "undo stage hunk" })
vim.keymap.set("n", "<leader>hU", "<cmd>Gitsigns reset_buffer_index<CR>", { desc = "reset buffer index" })
vim.keymap.set("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner hunk text object" })
vim.keymap.set("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner hunk text object" })
