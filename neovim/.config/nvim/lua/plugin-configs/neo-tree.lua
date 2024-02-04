local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

local savedview
require("neo-tree").setup({
  source_selector = {
    winbar = true,
    statusline = false,
  },
  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function()
        vim.cmd([[
          setlocal relativenumber
        ]])
      end,
    },
    -- {
    --   event = "before_render",
    --   handler = function()
    --     savedview = vim.fn.winsaveview()
    --   end,
    -- },
    -- {
    --   event = "after_render",
    --   handler = function()
    --     if savedview ~= nil then
    --       print("printing savedview: ")
    --       print(vim.inspect(savedview))
    --       vim.fn.winrestview(savedview)
    --     end
    --   end,
    -- },
  },
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = "*",
      highlight = "NeoTreeFileIcon",
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
  window = {
    position = "left",
    width = 65,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = "none",
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["<c-x>"] = "split_with_window_picker",
      ["<c-v>"] = "vsplit_with_window_picker",
      ["tn"] = "open_tabnew",
      ["t"] = "none",
      ["<c-s>"] = "open_with_window_picker",
      ["w"] = "none",
      ["<esc>"] = "none",
      ["C"] = "close_node",
      ["a"] = "add",
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["Y"] = function(state)
        local node = state.tree:get_node()
        vim.fn.setreg("+", node.name)
      end,
      ["<C-y>"] = function(state)
        local node = state.tree:get_node()
        local full_path = node.path
        local relative_path = full_path:sub(#state.path + 2)
        vim.fn.setreg("+", relative_path)
      end,
      ["x"] = "cut_to_clipboard",
      ["X"] = "close_all_nodes",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination
      ["m"] = "move", -- takes text input for destination
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["/"] = "none",
      ["?"] = "none",
      ["g?"] = "show_help",
      ["ge"] = function()
        vim.api.nvim_exec2("Neotree focus filesystem left", { output = true })
      end,
      ["gb"] = function()
        vim.api.nvim_exec2("Neotree focus buffers left", { output = true })
      end,
      ["gs"] = function()
        vim.api.nvim_exec2("Neotree focus git_status left", { output = true })
      end,
      ["z"] = "none",
    },
  },
  nesting_rules = {},
  filesystem = {
    follow_current_file = {
      enabled = false
    },
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta"
      },
      never_show = { -- remains hidden even if visible is toggled to true
        --".DS_Store",
        --"thumbs.db"
      },
    },
    renderers = {
      directory = {
        { "indent" },
        { "icon" },
        { "current_filter" },
        {
          "container",
          content = {
            { "name",        zindex = 10 },
            {
              "symlink_target",
              zindex = 10,
              highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard",   zindex = 10 },
            { "diagnostics", errors_only = true, zindex = 20,     align = "right",          hide_when_expanded = true },
            { "git_status",  zindex = 20,        align = "right", hide_when_expanded = true },
          },
        },
      },
      file = {
        { "indent" },
        { "icon" },
        {
          "container",
          content = {
            {
              "name",
              zindex = 10,
            },
            {
              "symlink_target",
              zindex = 10,
              highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard",   zindex = 10 },
            { "bufnr",       zindex = 10 },
            { "modified",    zindex = 20, align = "right" },
            { "diagnostics", zindex = 20, align = "right" },
            { "git_status",  zindex = 20, align = "right" },
          },
        },
      },
    },
    -- time the current file is changed while the tree is open.
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    window = {
      mappings = {
        ["tf"] = "telescope_find",
        ["tg"] = "telescope_grep",
        ["tr"] = "telescope_rawgrep",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "none",
        ["f"] = "filter_as_you_type",
        ["<c-f>"] = "clear_filter",
      },
    },
    commands = {
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
      end,
      telescope_rawgrep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope").extensions.live_grep_args.live_grep_args(getTelescopeOpts(state, path))
      end,
    },
  },
  buffers = {
    show_unloaded = true,
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
      },
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
})
vim.keymap.set({ "n" }, "<localleader>te", "<cmd>Neotree show toggle left<cr>", { desc = "Toggle neotree" })
vim.keymap.set({ "n" }, "<localleader>tc", "<cmd>Neotree close<cr>", { desc = "Close neotree" })
vim.keymap.set({ "n" }, "<leader>e", "<cmd>Neotree filesystem focus toggle left<cr>", { desc = "Neotree explorer" })
vim.keymap.set({ "n" }, "<leader>E", "<cmd>Neotree filesystem focus reveal left<cr>", { desc = "Neotree show file" })
