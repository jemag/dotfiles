require("neoscroll").setup({
  -- All these keys will be mapped to their corresponding default scrolling animation
  mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing_function = "quadratic", -- Default easing function
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  pre_hook = function()
    vim.opt.eventignore:append({
      'WinScrolled',
      'CursorMoved',
    })
  end,
  post_hook = function()
    vim.opt.eventignore:remove({
      'WinScrolled',
      'CursorMoved',
    })
  end,
})
