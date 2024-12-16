-- Lua
local actions = require("diffview.actions")

require("diffview").setup({
  diff_binaries = false, -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" }, -- The git executable followed by default args.
  use_icons = true, -- Requires nvim-web-devicons
  icons = { -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    listing_style = "tree", -- One of 'list' or 'tree'
    tree_options = { -- Only applies when listing_style is 'tree'
      flatten_dirs = true, -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = { -- See ':h diffview-config-win_config'
      position = "left",
      width = 70,
    },
  },
  file_history_panel = {
    log_options = { -- See ':h diffview-config-log_options'
      git = {
        single_file = {
          diff_merges = "combined",
        },
      },
      multi_file = {
        diff_merges = "first-parent",
      },
    },
    win_config = { -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
    },
  },
  commit_log_panel = {},
  default_args = { -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {
    diff_buf_read = function(bufnr)
      -- Change local options in diff buffers
      vim.opt_local.wrap = true
      vim.opt_local.list = true
    end,
  }, -- See ':h diffview-config-hooks'
})
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff view" })
vim.keymap.set("v", "<leader>gd", "<Esc><cmd>'<,'>DiffviewFileHistory --follow<cr>", { desc = "Range history" })
vim.keymap.set("n", "<leader>gc", ":DiffviewOpen ", { desc = "Diff custom" })
vim.keymap.set("n", "<leader>ghf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>ghd", "<cmd>DiffviewFileHistory %:p:h<cr>", { desc = "Directory history" })
vim.keymap.set("n", "<leader>ghg", "<cmd>DiffviewFileHistory<cr>", { desc = "Global history" })
