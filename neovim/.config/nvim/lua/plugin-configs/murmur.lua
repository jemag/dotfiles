require("murmur").setup({
  -- cursor_rgb = 'purple', -- default to '#393939'
  max_len = 80, -- maximum word-length to highlight
  -- min_len = 3,
  -- disable_on_lines = 2000, -- to prevent lagging on large files. Default to 2000 lines.
  exclude_filetypes = {},
  callbacks = {
    -- to trigger the close_events of vim.diagnostic.open_float.
    function()
      -- Close floating diag. and make it triggerable again.
      vim.cmd("doautocmd InsertEnter")
      vim.w.diag_shown = false
    end,
  },
})
