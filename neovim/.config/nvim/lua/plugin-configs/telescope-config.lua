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
    file_ignore_patterns = { "node_modules/", ".git/" },
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
        ["<C-q>"] = actions.send_to_qflist,
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
        },
        n = {
          ["<c-s>"] = require("telescope.actions").delete_buffer,
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
-- require('telescope').load_extension('fzy_native')
require("telescope").load_extension("media_files")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("aerial")

vim.cmd([[autocmd ColorScheme * highlight! TelescopeBorder guifg=white guibg=#1F2430]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptBorder guibg=#1F2430 guifg=white]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptNormal guibg=#1F2430 guifg=white ]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptPrefix guibg=#1F2430 guifg=#F29E74]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePreviewTitle guifg=black guibg=#BAE67E]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopePromptTitle guifg=black guibg=#F28779]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopeResultsTitle guifg=#626A73 guibg=#1F2430]])
vim.cmd([[autocmd ColorScheme * highlight! TelescopeSelectionCaret guifg=#77A8D9]])
-- vim.cmd([[autocmd ColorScheme * highlight! TelescopeNormal guifg=#E06C75]])
-- vim.cmd([[autocmd ColorScheme * highlight! TelescopeSelection guifg=#E06C75]])

vim.keymap.set("n", "<localleader>s/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in buffer" })
vim.keymap.set("n", "<localleader>s;", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<localleader>sa", "<cmd>Telescope aerial<cr>", { desc = "Search aerial" })
vim.keymap.set("n", "<localleader>sb", "<cmd>Telescope buffers<cr>", { desc = "Open buffers" })
vim.keymap.set("n", "<localleader>sB", "<cmd>Telescope builtin<cr>", { desc = "Telescope builtin" })
vim.keymap.set("n", "<localleader>sc", "<cmd>Telescope git_commits<cr>", { desc = "Commits" })
vim.keymap.set("n", "<localleader>sC", "<cmd>Telescope git_bcommits<cr>", { desc = "Buffer commits" })
vim.keymap.set(
  "n",
  "<localleader>sd",
  "<cmd>Telescope find_files hidden=true find_command=fd,--type,f, cwd=%:p:h<cr>",
  { desc = "Current file directory" }
)
vim.keymap.set("n", "<localleader>sD", "<cmd>Telescope live_grep cwd=%:p:h<cr>", { desc = "Current file directory text" })
vim.keymap.set("n", "<localleader>se", "<cmd>Telescope colorscheme<cr>", { desc = "Colorschemes" })
vim.keymap.set("n", "<localleader>sf", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Files" })
vim.keymap.set(
  "n",
  "<localleader>sF",
  "<cmd>Telescope find_files hidden=true find_command=fd,--type,f,--no-ignore-vcs<cr>",
  { desc = "Files, include ignored" }
)
vim.keymap.set("n", "<localleader>sg", "<cmd>lua require('telescope.builtin').grep_string({search=''})<cr>", { desc = "Grep string" })
vim.keymap.set("n", "<localleader>sG", "<cmd>Telescope git_status<cr>", { desc = "Modified git files" })
vim.keymap.set(
  "n",
  "<localleader>sh",
  "<cmd>lua require('telescope.builtin').command_history({sorter = require('telescope.sorters').get_substr_matcher()})<cr>",
  { desc = "Command history" }
)
vim.keymap.set("n", "<localleader>sH", "<cmd>Telescope command_history<cr>", { desc = "Fuzzy Command History" })
vim.keymap.set("n", "<localleader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<localleader>sl", "<cmd>Telescope loclist<cr>", { desc = "Location list" })
vim.keymap.set("n", "<localleader>sL", "<cmd>Telescope possession list<cr>", { desc = "Session list" })
vim.keymap.set("n", "<localleader>sm", "<cmd>Telescope man_pages<cr>", { desc = "Marks" })
vim.keymap.set("n", "<localleader>sM", "<cmd>Telescope media_files<cr>", { desc = "Media files" })
vim.keymap.set("n", "<localleader>sp", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
vim.keymap.set("n", "<localleader>sP", "<cmd>Telescope projects<cr>", { desc = "Projects" })
vim.keymap.set("n", "<localleader>sq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix" })
vim.keymap.set("n", "<localleader>sr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", { desc = "Raw rg" })
vim.keymap.set("n", "<localleader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP symbols" })
vim.keymap.set("n", "<localleader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Dynamic symbols" })
vim.keymap.set("n", "<localleader>st", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<localleader>sV", "<cmd>Telescope vim_options<cr>", { desc = "Vim options" })
vim.keymap.set("n", "<localleader>sy", "<cmd>Telescope filetypes<cr>", { desc = "File types" })
vim.keymap.set("n", "<localleader>s.", "<cmd>Telescope resume<cr>", { desc = "Resume last search" })
