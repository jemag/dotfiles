local cmp = require("cmp")
local luasnip = require("luasnip")
-- lazy load all vscode like snippets
require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "⌘",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Codeium = "",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "廓",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  performance = {
    debounce = 150,
    max_view_entries = 20,
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s", "c" }),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s", "c" }),
    -- ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<esc>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<C-Space>"] = cmp.mapping.complete(),
    -- ['<C-e>'] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
  },
  sources = {
    { name = "nvim_lsp", max_item_count = 30 },
    { name = "path" },
    { name = "luasnip" },
    { name = "codeium" },
    { name = "buffer" },
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(_, item)
      item.kind = " " .. icons[item.kind] .. " " .. item.kind
      return item
    end,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      -- winhighlight = "NormalFloat:Normal",
    },
  },
  experimental = {
    ghost_text = false
    -- ghost_text = {
    --   hl_group = "LspCodeLens",
    -- },
  },
})
-- vim.keymap.set("i", "<c-x><c-f>", function()
--   require("cmp").complete({
--     config = {
--       completion = {
--         get_trigger_characters = function(trigger_characters)
--           print('inside get_trigger_characters')
--           return {}
--         end
--       },
--       sources = {
--         {
--           name = "fuzzy_path",
--           keyword_length = 0,
--           keyword_pattern = ".*?",
--           trigger_characters = { ''}
--         },
--       },
--     },
--   })
-- end)
vim.keymap.set("i", "<c-x><c-r>", function()
  require("cmp").complete({
    config = {
      sources = {
        {
          name = "rg",
        },
      },
    },
  })
end)
