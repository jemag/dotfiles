local cmp = require("cmp")
require("cmp").setup.cmdline(":", {
  mapping = {
    ["<c-f>"] = cmp.mapping({
      c = cmp.mapping.close(),
    }),
  },
  sources = {
    { name = "path" },
    { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=], max_item_count = 15 },
    { name = "cmdline_history", max_item_count = 10 },
  },
})
