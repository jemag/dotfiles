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
  attachments = {
    img_folder = "_resources",
  },
  ui = {
    enable = false,
  },
  new_notes_subdir = "current_dir",
  mappings = {
    -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true, desc = "Follow link" },
    },
    -- Toggle check-boxes.
    ["<leader>oc"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true, desc = "Toggle checkbox"},
    },
  },
  -- Optional, customize how note file names are generated given the ID, target directory, and title.
  ---@param spec { id: string, dir: obsidian.Path, title: string|? }
  ---@return string|obsidian.Path The full path to the new note.
  note_path_func = function(spec)
    -- This is equivalent to the default behavior.
    local path = spec.dir / tostring(spec.title)
    return path:with_suffix(".md")
  end,
  wiki_link_func = "prepend_note_path",
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,
})

vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
vim.keymap.set("x", "<leader>oe", ":ObsidianExtractNote<cr>", { desc = "Extract to note" })
vim.keymap.set("n", "<leader>og", "<cmd>ObsidianSearch<cr>", { desc = "Grep in notes" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste img" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>os", function()
  require("telescope.builtin").find_files({ cwd = vim.env.OBSIDIAN_VAULT, search_file = "*.md" })
end, { desc = "Quick switch" })
vim.keymap.set("n", "<leader>oS", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Obidian.nvim quick switch" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Today" })
vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", { desc = "Template" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday" })
