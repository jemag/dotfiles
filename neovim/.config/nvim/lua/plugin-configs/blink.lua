require("blink-cmp").setup({
  keymap = {
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Esc>"] = { "hide", "fallback" },
    ["<C-y>"] = { "select_and_accept" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-j>"] = { "snippet_forward", "fallback" },
  },
  -- accept = {
  --   auto_brackets = {
  --     enabled = true,
  --   },
  -- },
  completion = {
    documentation = {
      -- Controls whether the documentation window will automatically show when selecting a completion item
      auto_show = true,
      auto_show_delay_ms = 500,
      update_delay_ms = 50,
    },
  },
  sources = {
    -- add lazydev to your completion providers
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },
})
