require("blink-cmp").setup({
  cmdline = {
    enabled = true,
    keymap = {
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-y>"] = { "select_and_accept" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-f>"] = { "fallback" },
      ["up"] = { "fallback" },
      ["down"] = { "fallback" },
      ["<C-b>"] = {
        function(cmp)
          cmp.show({ providers = { "path" } })
        end,
      },
    },
    completion = {
      menu = {
        auto_show = true,
      },
      list = {
        selection = {
          auto_insert = false,
        },
      },
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  keymap = {
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Esc>"] = { "hide", "fallback" },
    ["<C-y>"] = { "select_and_accept" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-j>"] = { "snippet_forward", "fallback" },
    ["<C-k>"] = { "snippet_backward", "fallback" },
    ["<C-f>"] = { "fallback" },
    ["up"] = { "fallback" },
    ["down"] = { "fallback" },
    ["<C-b>"] = {
      function(cmp)
        cmp.show({ providers = { "path" } })
      end,
    },
  },
  -- accept = {

  --     enabled = true,
  --   },
  -- },
  completion = {
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
    list = {
      selection = {
        auto_insert = false,
      },
    },
    documentation = {
      -- Controls whether the documentation window will automatically show when selecting a completion item
      auto_show = true,
      auto_show_delay_ms = 500,
      update_delay_ms = 50,
      window = {
        border = "single",
      },
    },
    menu = {
      border = "single",
    },
  },
  signature = {
    window = {
      border = "single",
    },
  },
  sources = {
    -- add lazydev to your completion providers
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      cmdline = {
        -- ignores cmdline completions when executing shell commands
        enabled = function()
          return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!?|term")
        end,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "highlight! link BlinkCmpMenu Normal",
  desc = "Link BlinkCMPMenu to Normal",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "highlight! link BlinkCmpMenuBorder Normal",
  desc = "Link BlinkCMPMenuBorder to Normal",
})
