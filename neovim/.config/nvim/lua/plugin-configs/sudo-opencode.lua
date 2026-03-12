require("opencode").setup({
  preferred_picker = "snacks", -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
  preferred_completion = "blink", -- 'blink', 'nvim-cmp','vim_complete' if nil, it will use the best available completion
  default_global_keymaps = true, -- If false, disables all default global keymaps
  default_mode = "plan", -- 'build' or 'plan' or any custom configured. @see [OpenCode Agents](https://opencode.ai/docs/modes/)
  default_system_prompt = nil, -- Custom system prompt to use for all sessions. If nil, uses the default built-in system prompt
  keymap_prefix = "<localleader>o", -- Default keymap prefix for global keymaps change to your preferred prefix and it will be applied to all keymaps starting with <leader>o
  opencode_executable = "opencode", -- Name of your opencode binary
  keymap = {
    editor = {
      ["<f11>"] = { "toggle", mode = { "n", "i" } }, -- Open opencode. Close if opened
      -- ["<localleader>oi"] = { "open_input" }, -- Opens and focuses on input window on insert mode
      -- ["<localleader>oI"] = { "open_input_new_session" }, -- Opens and focuses on input window on insert mode. Creates a new session
      -- ["<localleader>oo"] = { "open_output" }, -- Opens and focuses on output window
      -- ["<localleader>ot"] = { "toggle_focus" }, -- Toggle focus between opencode and last window
      -- ["<localleader>oT"] = { "timeline" }, -- Display timeline picker to navigate/undo/redo/fork messages
      -- ["<localleader>oq"] = { "close" }, -- Close UI windows
      -- ["<localleader>os"] = { "select_session" }, -- Select and load a opencode session
      -- ["<localleader>oR"] = { "rename_session" }, -- Rename current session
      -- ["<localleader>op"] = { "configure_provider" }, -- Quick provider and model switch from predefined list
      -- ["<localleader>oV"] = { "configure_variant" }, -- Switch model variant for the current model
      -- ["<localleader>oy"] = { "add_visual_selection", mode = { "v" } },
      -- ["<localleader>oz"] = { "toggle_zoom" }, -- Zoom in/out on the Opencode windows
      -- ["<localleader>ov"] = { "paste_image" }, -- Paste image from clipboard into current session
      -- ["<localleader>od"] = { "diff_open" }, -- Opens a diff tab of a modified file since the last opencode prompt
      -- ["<localleader>o]"] = { "diff_next" }, -- Navigate to next file diff
      -- ["<localleader>o["] = { "diff_prev" }, -- Navigate to previous file diff
      -- ["<localleader>oc"] = { "diff_close" }, -- Close diff view tab and return to normal editing
      -- ["<localleader>ora"] = { "diff_revert_all_last_prompt" }, -- Revert all file changes since the last opencode prompt
      -- ["<localleader>ort"] = { "diff_revert_this_last_prompt" }, -- Revert current file changes since the last opencode prompt
      -- ["<localleader>orA"] = { "diff_revert_all" }, -- Revert all file changes since the last opencode session
      -- ["<localleader>orT"] = { "diff_revert_this" }, -- Revert current file changes since the last opencode session
      -- ["<localleader>orr"] = { "diff_restore_snapshot_file" }, -- Restore a file to a restore point
      -- ["<localleader>orR"] = { "diff_restore_snapshot_all" }, -- Restore all files to a restore point
      -- ["<localleader>ox"] = { "swap_position" }, -- Swap Opencode pane left/right
      -- ["<localleader>ott"] = { "toggle_tool_output" }, -- Toggle tools output (diffs, cmd output, etc.)
      -- ["<localleader>otr"] = { "toggle_reasoning_output" }, -- Toggle reasoning output (thinking steps)
      -- ["<localleader>o/"] = { "quick_chat", mode = { "n", "x" } }, -- Open quick chat input with selection context in visual mode or current line context in normal mode
    },
    input_window = {
      ["<C-s>"] = { "submit_input_prompt", mode = { "n", "i" } }, -- Submit prompt (normal mode and insert mode)
      ["<esc>"] = { false }, -- Close UI windows
      -- ["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
      -- ["<localleader>os"] = { "select_session" }, -- Select and load a opencode session
      -- ["~"] = { "mention_file", mode = "i" }, -- Pick a file and add to context. See File Mentions section
      -- ["@"] = { "mention", mode = "i" }, -- Insert mention (file/agent)
      -- ["/"] = { "slash_commands", mode = "i" }, -- Pick a command to run in the input window
      -- ["#"] = { "context_items", mode = "i" }, -- Manage context items (current file, selection, diagnostics, mentioned files)
      -- ["<M-v>"] = { "paste_image", mode = "i" }, -- Paste image from clipboard as attachment
      -- ["<C-i>"] = { "focus_input", mode = { "n", "i" } }, -- Focus on input window and enter insert mode at the end of the input from the output window
      -- ["<tab>"] = { false }, -- Toggle between input and output panes
      -- ["<up>"] = { "prev_prompt_history", mode = { "n", "i" } }, -- Navigate to previous prompt in history
      -- ["<down>"] = { "next_prompt_history", mode = { "n", "i" } }, -- Navigate to next prompt in history
      -- ["<M-m>"] = { "switch_mode", mode = { "n", "i" } }, -- Switch between modes (build/plan)
      -- ["<M-r>"] = { "cycle_variant", mode = { "n", "i" } }, -- Cycle through available model variants
      ["<C-h>"] = {
        function()
          require("smart-splits").move_cursor_left()
          vim.cmd("stopinsert")
        end,
        mode = { "i" },
      }, -- Navigate to window on the left
      ["<C-j>"] = {
        function()
          require("smart-splits").move_cursor_down()
          vim.cmd("stopinsert")
        end,
        mode = { "i" },
      }, -- Navigate to window below
      ["<C-k>"] = {
        function()
          require("smart-splits").move_cursor_up()
          vim.cmd("stopinsert")
        end,
        mode = { "i" },
      }, -- Navigate to window above
      ["<C-l>"] = {
        function()
          require("smart-splits").move_cursor_right()
          vim.cmd("stopinsert")
        end,
        mode = { "i" },
      }, -- Navigate to window on the right
    },
    output_window = {
      -- ["<esc>"] = { "close" }, -- Close UI windows
      -- ["<C-c>"] = { "cancel" }, -- Cancel opencode request while it is running
      -- ["]]"] = { "next_message" }, -- Navigate to next message in the conversation
      -- ["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
      -- ["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
      -- ["i"] = { "focus_input", "n" }, -- Focus on input window and enter insert mode at the end of the input from the output window
      -- ["<M-r>"] = { "cycle_variant", mode = { "n" } }, -- Cycle through available model variants
      -- ["<localleader>oS"] = { "select_child_session" }, -- Select and load a child session
      -- ["<localleader>oD"] = { "debug_message" }, -- Open raw message in new buffer for debugging
      -- ["<localleader>oO"] = { "debug_output" }, -- Open raw output in new buffer for debugging
      -- ["<localleader>ods"] = { "debug_session" }, -- Open raw session in new buffer for debugging
    },
    session_picker = {
      rename_session = { "<C-r>" }, -- Rename selected session in the session picker
      delete_session = { "<C-d>" }, -- Delete selected session in the session picker
      new_session = { "<C-s>" }, -- Create and switch to a new session in the session picker
    },
    timeline_picker = {
      undo = { "<C-u>", mode = { "i", "n" } }, -- Undo to selected message in timeline picker
      fork = { "<C-f>", mode = { "i", "n" } }, -- Fork from selected message in timeline picker
    },
    history_picker = {
      delete_entry = { "<C-d>", mode = { "i", "n" } }, -- Delete selected entry in the history picker
      clear_all = { "<C-X>", mode = { "i", "n" } }, -- Clear all entries in the history picker
    },
    model_picker = {
      toggle_favorite = { "<C-f>", mode = { "i", "n" } },
    },
    mcp_picker = {
      toggle_connection = { "<C-t>", mode = { "i", "n" } }, -- Toggle MCP server connection in the MCP picker
    },
  },
  ui = {
    enable_treesitter_markdown = true, -- Use Treesitter for markdown rendering in the output window (default: true).
    position = "right", -- 'right' (default), 'left' or 'current'. Position of the UI split. 'current' uses the current window for the output.
    input_position = "bottom", -- 'bottom' (default) or 'top'. Position of the input window
    window_width = 0.40, -- Width as percentage of editor width
    zoom_width = 0.8, -- Zoom width as percentage of editor width
    display_model = true, -- Display model name on top winbar
    display_context_size = true, -- Display context size in the footer
    display_cost = true, -- Display cost in the footer
    window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder", -- Highlight group for the opencode window
    persist_state = true, -- Keep buffers when toggling/closing UI so window state restores quickly
    icons = {
      preset = "nerdfonts", -- 'nerdfonts' | 'text'. Choose UI icon style (default: 'nerdfonts')
      overrides = {}, -- Optional per-key overrides, see section below
    },
    output = {
      tools = {
        show_output = true, -- Show tools output [diffs, cmd output, etc.] (default: true)
        show_reasoning_output = false, -- Show reasoning/thinking steps output (default: true)
      },
      rendering = {
        markdown_debounce_ms = 250, -- Debounce time for markdown rendering on new data (default: 250ms)
        on_data_rendered = nil, -- Called when new data is rendered; set to false to disable default RenderMarkdown/Markview behavior
      },
    },
    input = {
      min_height = 0.10, -- min height of prompt input as percentage of window height
      max_height = 0.25, -- max height of prompt input as percentage of window height
      text = {
        wrap = true, -- Wraps text inside input window
      },
      -- Auto-hide input window when prompt is submitted or focus switches to output window
      auto_hide = false,
    },
    picker = {
      snacks_layout = nil, -- `layout` opts to pass to Snacks.picker.pick({ layout = ... })
    },
    completion = {
      file_sources = {
        enabled = true,
        preferred_cli_tool = "server", -- 'fd','fdfind','rg','git','server' if nil, it will use the best available tool, 'server' uses opencode cli to get file list (works cross platform) and supports folders
        ignore_patterns = {
          "^%.git/",
          "^%.svn/",
          "^%.hg/",
          "node_modules/",
          "%.pyc$",
          "%.o$",
          "%.obj$",
          "%.exe$",
          "%.dll$",
          "%.so$",
          "%.dylib$",
          "%.class$",
          "%.jar$",
          "%.war$",
          "%.ear$",
          "target/",
          "build/",
          "dist/",
          "out/",
          "deps/",
          "%.tmp$",
          "%.temp$",
          "%.log$",
          "%.cache$",
        },
        max_files = 10,
        max_display_length = 50, -- Maximum length for file path display in completion, truncates from left with "..."
      },
    },
  },
  context = {
    enabled = false, -- Enable automatic context capturing
    cursor_data = {
      enabled = false, -- Include cursor position and line content in the context
      context_lines = 5, -- Number of lines before and after cursor to include in context
    },
    diagnostics = {
      info = false, -- Include diagnostics info in the context (default to false
      warn = true, -- Include diagnostics warnings in the context
      error = true, -- Include diagnostics errors in the context
      only_closest = false, -- If true, only diagnostics for cursor/selection
    },
    current_file = {
      enabled = false, -- Include current file path and content in the context
      show_full_path = true,
    },
    files = {
      enabled = true,
      show_full_path = true,
    },
    selection = {
      enabled = true, -- Include selected text in the context
    },
    buffer = {
      enabled = false, -- Disable entire buffer context by default, only used in quick chat
    },
    git_diff = {
      enabled = false,
    },
  },
  logging = {
    enabled = false,
    level = "warn", -- debug, info, warn, error
    outfile = nil,
  },
  debug = {
    enabled = false, -- Enable debug messages in the output window
    capture_streamed_events = false,
    show_ids = true,
    quick_chat = {
      keep_session = false, -- Keep quick_chat sessions for inspection, this can pollute your sessions list
      set_active_session = false,
    },
  },
  prompt_guard = nil, -- Optional function that returns boolean to control when prompts can be sent (see Prompt Guard section)

  -- User Hooks for custom behavior at certain events
  hooks = {
    on_file_edited = nil, -- Called after a file is edited by opencode.
    on_session_loaded = nil, -- Called after a session is loaded.
    on_done_thinking = nil, -- Called when opencode finishes thinking (all jobs complete).
    on_permission_requested = nil, -- Called when a permission request is issued.
  },
  quick_chat = {
    default_model = nil, -- works better with a fast model like gpt-4.1
    default_agent = "plan", -- plan ensure no file modifications by default
    instructions = nil, -- Use built-in instructions if nil
  },
})
