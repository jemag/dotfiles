local vault_dir = vim.env.OBSIDIAN_VAULT
require("obsidian").setup({
  dir = vault_dir,

  -- Optional, completion.
  completion = {
    -- If using nvim-cmp, otherwise set to false
    nvim_cmp = false,
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
    ["<leader>oC"] = {
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

local _add_checkbox = function(character, line_num)
	local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]

	local checkbox_pattern = "^%s*- %[.] "
	local checkbox = character or " "

	if not string.match(line, checkbox_pattern) then
		local unordered_list_pattern = "^(%s*)[-*+] (.*)"
		if string.match(line, unordered_list_pattern) then
			line = string.gsub(line, unordered_list_pattern, "%1- [ ] %2")
		else
			line = string.gsub(line, "^(%s*)", "%1- [ ] ")
		end
	end
	local capturing_checkbox_pattern = "^(%s*- %[).(%] )"
	line = string.gsub(line, capturing_checkbox_pattern, "%1" .. checkbox .. "%2")

	-- 0-indexed
	vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
end

local _remove_checkbox = function(line_num)
	local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
	local checkbox_pattern = "^%s*- %[.]. "
	local capturing_checkbox_pattern = "^(%s*-) %[.%] (.*)"
	line = string.gsub(line, capturing_checkbox_pattern, "%1 %2")
	line = string.gsub(line, checkbox_pattern, "")
	-- 0-indexed
	vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
end


local toggle_checkbox = function(character)
	-- Check if we are in visual line mode
	local mode = vim.api.nvim_get_mode().mode

	local toggle_or_remove = function(character, line_num)
		if (character == nil) then
			-- Remove checkbox
			_remove_checkbox(line_num)
		else
			-- Add checkbox
			_add_checkbox(character, line_num)
		end
	end

	if mode == 'V' or mode == 'v' then
		-- Get the range of selected lines
		vim.cmd([[execute "normal! \<ESC>"]])
		local vstart = vim.fn.getcharpos("'<")
		local vend = vim.fn.getcharpos("'>")

		local line_start = vstart[2]
		local line_end = vend[2]

		-- Iterate over each line in the range and apply the transformation
		for line_num = line_start, line_end do
			toggle_or_remove(character, line_num)
		end
	else
		-- Normal mode
		-- Allow line_num to be optional, defaulting to the current line if not provided (normal mode)
		local line_num = unpack(vim.api.nvim_win_get_cursor(0))
		toggle_or_remove(character, line_num)
	end
end
vim.keymap.set({"n", "v"}, "<leader>ox", function() toggle_checkbox("x") end, { desc="Set checkbox", noremap = true })
vim.keymap.set({"n", "v"}, "<leader>oc", function() toggle_checkbox(" ") end, { desc="Clear checkbox", noremap = true })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
vim.keymap.set("x", "<leader>oe", ":ObsidianExtractNote<cr>", { desc = "Extract to note" })
vim.keymap.set("n", "<leader>og", "<cmd>ObsidianSearch<cr>", { desc = "Grep in notes" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste img" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>os", function()
  require("snacks.picker").files({ cwd = vim.env.OBSIDIAN_VAULT, args = { "--glob", "*.md"  }})
end, { desc = "Quick switch" })
vim.keymap.set("n", "<leader>oS", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Obidian.nvim quick switch" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Tags" })
vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", { desc = "Template" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday" })
