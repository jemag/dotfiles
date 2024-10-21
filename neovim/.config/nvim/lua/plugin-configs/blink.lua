require("blink-cmp").setup({
  keymap = {
    show = "<C-space>",
    hide = "<Esc>",
    accept = "<C-y>",
    -- select_and_accept = {},
    select_prev = { "<Up>", "<C-p>" },
    select_next = { "<Down>", "<C-n>" },

    show_documentation = "<C-space>",
    hide_documentation = "<C-space>",
    scroll_documentation_up = "<C-u>",
    scroll_documentation_down = "<C-d>",

    snippet_forward = "<C-j>",
    snippet_backward = "<C-k>",
  },
  -- accept = {
  --   auto_brackets = {
  --     enabled = true,
  --   },
  -- },
  windows = {
    documentation = {
      -- Controls whether the documentation window will automatically show when selecting a completion item
      auto_show = true,
      auto_show_delay_ms = 500,
      update_delay_ms = 50,
    },
  },
})
