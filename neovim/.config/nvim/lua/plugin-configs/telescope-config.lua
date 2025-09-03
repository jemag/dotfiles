-- Global remapping
------------------------------
local action_state = require("telescope.actions.state")
local action_mt = require("telescope.actions.mt")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")

local custom_actions = {}

custom_actions.yank_entry = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  vim.fn.setreg("+", entry.value)
  actions.close(prompt_bufnr)
end

local pick_window = function(prompt_bufnr, direction)
  -- Use nvim-window-picker to choose the window by dynamically attaching a function
  local picker = action_state.get_current_picker(prompt_bufnr)
  picker.get_selection_window = function(pickr, _)
    local picked_window_id = require("window-picker").pick_window({ autoselect_one = true, include_current_win = true })
      or vim.api.nvim_get_current_win()
    -- Unbind after using so next instance of the picker acts normally
    pickr.get_selection_window = nil
    return picked_window_id
  end

  action_set.select(prompt_bufnr, direction)
  vim.cmd("stopinsert")
end

local pick_vertical = function(prompt_bufnr)
  pick_window(prompt_bufnr, "vertical")
end
local pick_horizontal = function(prompt_bufnr)
  pick_window(prompt_bufnr, "horizontal")
end
local pick_default = function(prompt_bufnr)
  pick_window(prompt_bufnr, "default")
end

-- turn functions in M to actions s.t. you can do cool stuff like M.my_action:{replace, replace_if, enhance, ...}, M.my_action + M.my_other_action, etc.
custom_actions = action_mt.transform_mod(custom_actions)

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    file_ignore_patterns = { "node_modules/", ".git/", ".attachments/" },
    prompt_prefix = " ",
    selection_caret = "󰼛 ",
    entry_prefix = "  ",
    initial_mode = "insert",
    path_display = { "relative" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        mirror = false,
        width = 0.95,
        height = 0.95,
        preview_width = 0.5,
      },
      vertical = {
        mirror = false,
        width = 0.95,
        height = 0.95,
        prompt_position = "bottom",
      },
    },
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        -- ["<c-x>"] = false,
        ["<esc>"] = actions.close,
        ["<F6>"] = actions.close,
        ["<C-q>"] = actions.send_to_qflist,
        ["<C-l>"] = actions.send_to_loclist,
        ["<C-y>"] = custom_actions.yank_entry,
        ["<C-v>"] = pick_vertical,
        ["<C-s>"] = pick_horizontal,
        ["<C-e>"] = pick_default,
        -- ["<C-u>"] = false,
        -- Otherwise, just set the mapping to the function that you want it to be.
        -- ["<C-i>"] = actions.select_horizontal,

        -- Add up multiple actions
        -- ["<CR>"] = actions.select_default + actions.center

        -- You can perform as many actions in a row as you like
        -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
      },
      n = {
        ["<C-q>"] = actions.send_to_qflist,
        ["<C-y>"] = custom_actions.yank_entry,
        --[[ ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist, ]]
        -- ["<C-i>"] = my_cool_custom_action,
      },
    },
  },
  pickers = {
    -- Your special builtin config goes in here
    buffers = {
      sort_lastused = false,
      sort_mru = true,
      mappings = {
        i = {
          ["<c-x>"] = actions.delete_buffer,
        },
        n = {
          ["<c-x>"] = actions.delete_buffer,
        },
      },
    },
    git_status = {
      mappings = {
        i = {
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<c-s>"] = actions.git_staging_toggle,
        },
        n = {
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<c-s>"] = actions.git_staging_toggle,
        },
      },
    },
  },
  extensions = {
    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = {
        ["_"] = false, -- This key will be the default
        json = true, -- You can set the option for specific filetypes
        yaml = true,
      },
    },
    undo = {
      use_delta = true,
      use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
      side_by_side = false,
      vim_diff_opts = {
        ctxlen = vim.o.scrolloff,
      },
      entry_format = "state #$ID, $STAT, $TIME",
      mappings = {
        i = {
          ["<cr>"] = require("telescope-undo.actions").yank_additions,
          ["<c-f>"] = require("telescope-undo.actions").yank_deletions,
          ["<C-r>"] = require("telescope-undo.actions").restore,
        },
      },
    },
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = { "png", "webp", "jpg", "jpeg" },
      find_cmd = "rg", -- find command (defaults to `fd`)
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),
    },
  },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("diff")
-- require('telescope').load_extension('fzy_native')
require("telescope").load_extension("media_files")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("aerial")
require("telescope").load_extension("lazy")
require("telescope").load_extension("undo")
require("telescope").load_extension("menufacture")
require('telescope').load_extension('bookmarks')

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])

local function set_telescope_colors()
  if vim.g.colors_name == "ayu" then
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "white", bg = "#1F2430" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#1F2430", fg = "white" })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#1F2430", fg = "white" })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = "#1F2430", fg = "#F29E74" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "black", bg = "#BAE67E" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#626A73", bg = "#1F2430" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#77A8D9" })
  end
  vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { link = "Normal" })
  vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "black", bg = "#F28779" })
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    set_telescope_colors()
  end,
})

vim.keymap.set("n", "<leader>sa", "<cmd>Telescope aerial<cr>", { desc = "Search aerial" })
-- vim.keymap.set("n", "<leader>sf", function()
--   require("telescope").extensions.menufacture.find_files({ hidden = true })
-- end, { desc = "Files" })
vim.keymap.set("n", "<leader>sM", "<cmd>Telescope media_files<cr>", { desc = "Media files" })
vim.keymap.set("n", "<leader>sr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", { desc = "Raw rg" })
-- vim.keymap.set("n", "<leader>st", require("telescope").extensions.menufacture.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sV", "<cmd>Telescope vim_options<cr>", { desc = "Vim options" })
vim.keymap.set("n", "<leader>sY", "<cmd>Telescope filetypes<cr>", { desc = "File types" })

vim.keymap.set("n", "<leader>sC", function()
  require("telescope").extensions.diff.diff_files({ hidden = true })
end, { desc = "Compare 2 files" })
vim.keymap.set("n", "<leader>sc", function()
  require("telescope").extensions.diff.diff_current({ hidden = true })
end, { desc = "Compare file with current" })

-- vim.api.nvim_create_autocmd("WinLeave", {
--   callback = function()
--     if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
--     end
--   end,
-- })
