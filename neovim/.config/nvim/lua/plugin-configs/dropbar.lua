require("dropbar").setup({
  bar = {
    truncate = false,
    sources = function(buf, _)
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")
      if vim.bo[buf].ft == "markdown" then
        return { sources.markdown }
      end
      if vim.bo[buf].buftype == "terminal" then
        return { sources.terminal }
      end
      return { sources.path, utils.source.fallback({ sources.lsp, sources.treesitter }) }
    end,
  },
  sources = {
    -- treesitter = {
    --   max_depth = 1,
    -- },
    -- lsp = {
    --   max_depth = 1,
    -- },
    path = {
      max_depth = 1,
      modified = function(sym)
        return sym:merge({
          name = sym.name .. "  ",
          -- icon = " ",
          name_hl = "DiffAdded",
          -- icon_hl = "DiffAdded",
          -- ...
        })
      end,
    },
  },
})
