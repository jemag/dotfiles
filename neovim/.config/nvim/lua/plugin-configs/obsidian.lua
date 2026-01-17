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
