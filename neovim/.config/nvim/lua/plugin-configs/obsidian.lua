local vault_dir = vim.env.OBSIDIAN_VAULT
require("obsidian").setup({
  dir = vault_dir,

  -- Optional, completion.
  completion = {
    -- If using nvim-cmp, otherwise set to false
    nvim_cmp = true,
    -- Trigger completion at 2 chars
    min_chars = 2,
  },
  finder = "telescope.nvim",
  open_notes_in = "current",
  mappings = {},
  attachments = {
    img_folder = "_resources"
  },
  ui = {
    enable = false,
  }
})

vim.keymap.set("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { noremap = false, expr = true })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
vim.keymap.set("n", "<leader>og", "<cmd>ObsidianSearch<cr>", { desc = "Grep in notes" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste img" })
-- vim.keymap.set("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch" })
vim.keymap.set("n", "<leader>os",function ()
  require("telescope.builtin").find_files({ cwd = vim.env.OBSIDIAN_VAULT, search_file = "*.md" })
end, { desc = "Quick switch" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "Today" })
vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", { desc = "Template" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday" })
