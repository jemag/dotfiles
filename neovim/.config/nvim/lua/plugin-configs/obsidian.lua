local vault_dir = vim.env.OBSIDIAN_VAULT
require("obsidian").setup({
  legacy_commands = false,
  footer = {
    enabled = false,
  },
  workspaces = {
    {
      name = "obsidian",
      path = vault_dir,
    },
  },

  -- Optional, completion.
  picker = {
    name = "snacks.pick",
  },
  completion = {
    -- If using nvim-cmp, otherwise set to false
    nvim_cmp = false,
    blink = false,
    create_new = false,
    -- Trigger completion at 2 chars
    min_chars = 2,
  },
  finder = "snacks.pick",
  open_notes_in = "current",
  attachments = {
    folder = "_resources",
  },
  ui = {
    enable = false,
  },
  new_notes_subdir = "current_dir",
  note_id_func = function(title)
    if title == nil then
      return nil
    end

    -- Keep the title as-is
    return title
  end,
  wiki_link_func = "prepend_note_path",
})
