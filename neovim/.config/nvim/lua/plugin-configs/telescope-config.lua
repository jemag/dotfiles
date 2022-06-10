-- Global remapping
------------------------------
local actions = require("telescope.actions")
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
    file_ignore_patterns = { "node_modules", ".git" },
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
    path_display = { "absolute" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
        width = 0.95,
      },
      vertical = {
        mirror = false,
      },
    },
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        -- ["<c-x>"] = false,
        ["<esc>"] = actions.close,
        ["<C-s>"] = actions.send_selected_to_qflist,
        ["<C-q>"] = actions.send_to_qflist,
        -- Otherwise, just set the mapping to the function that you want it to be.
        -- ["<C-i>"] = actions.select_horizontal,

        -- Add up multiple actions
        -- ["<CR>"] = actions.select_default + actions.center

        -- You can perform as many actions in a row as you like
        -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
      },
      n = {
        ["<C-s>"] = actions.send_selected_to_qflist,
        ["<C-q>"] = actions.send_to_qflist,
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
      mappings = {
        i = {
          ["<c-s>"] = require("telescope.actions").delete_buffer,
          -- or right hand side can also be a the name of the action as string
          -- ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-s>"] = require("telescope.actions").delete_buffer,
        },
      },
    },
  },
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = { "png", "webp", "jpg", "jpeg" },
      find_cmd = "rg", -- find command (defaults to `fd`)
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
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
-- require('telescope').load_extension('fzy_native')
require("telescope").load_extension("media_files")
require("telescope").load_extension("live_grep_args")

vim.cmd([[autocmd ColorScheme * highlight! TelescopeBorder guifg=white guibg=#1F2430]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptBorder guibg=#1F2430 guifg=white]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptNormal guibg=#1F2430 guifg=white ]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptPrefix guibg=#1F2430 guifg=#F29E74]])
-- vim.cmd([[autocmd ColorScheme * highlight! TelescopeNormal guifg=#E06C75]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePreviewTitle guifg=black guibg=#BAE67E]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptTitle guifg=black guibg=#F28779]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopeResultsTitle guifg=#626A73 guibg=#1F2430]])
-- vim.cmd([[autocmd ColorScheme * highlight! TelescopeSelection guifg=#E06C75]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopeSelectionCaret guifg=#77A8D9]])
