require("trailblazer").setup(
  -- Adjust these values to your liking
  {
    lang = "en",
    auto_save_trailblazer_state_on_exit = true,
    -- WARN: Currently autoload crashes
    auto_load_trailblazer_state_on_enter = false,
    trail_options = {
      -- Available modes to cycle through. Remove any you don't need.
      available_trail_mark_modes = {
        "global_chron",
        "buffer_local_line_sorted",
      },
      -- The current / initially selected trail mark selection mode. Choose from one of the
      -- available modes: global_chron, global_buf_line_sorted, global_chron_buf_line_sorted,
      -- global_chron_buf_switch_group_chron, global_chron_buf_switch_group_line_sorted,
      -- buffer_local_chron, buffer_local_line_sorted
      current_trail_mark_mode = "buffer_local_line_sorted",
      verbose_trail_mark_select = true, -- print current mode notification on mode change
      newest_mark_symbol = "⬤", -- disable this mark symbol by setting its value to ""
      cursor_mark_symbol = "⬤", -- disable this mark symbol by setting its value to ""
      next_mark_symbol = "⬤", -- disable this mark symbol by setting its value to ""
      previous_mark_symbol = "⬤", -- disable this mark symbol by setting its value to ""
      multiple_mark_symbol_counters_enabled = true,
      number_line_color_enabled = false,
      symbol_line_enabled = true,
    },
    mappings = {
      nv = { -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
        motions = {
          new_trail_mark = "<A-a>",
          track_back = "<A-b>",
          peek_move_next_down = "<A-j>",
          peek_move_previous_up = "<A-k>",
          move_to_nearest = '<A-n>',
          toggle_trail_mark_list = "<A-m>",
        },
        actions = {
          delete_all_trail_marks = "<A-d>",
          paste_at_last_trail_mark = false,
          paste_at_all_trail_marks = false,
          set_trail_mark_select_mode = "<A-t>",
        },
      },
      -- You can also add/move any motion or action to mode specific mappings i.e.:
      -- i = {
      --     motions = {
      --         new_trail_mark = '<C-l>',
      --         ...
      --     },
      --     ...
      -- },
    },
  }
)
