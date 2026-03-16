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

  link = {
    format = "relative",
    style= "markdown",
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "ObsidianNoteEnter",
  callback = function(ev)
    -- remove the default mappings
    vim.keymap.del("n", "<CR>", { buffer = true })

    -- replace with my own
    vim.keymap.set("n", "<leader><cr>", require("obsidian.api").smart_action, { expr = true, buffer = true })
  end,
})
