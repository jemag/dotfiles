local sj = require("sj")
sj.setup({
  auto_jump = false,
  separator = ";",
  highlights_timeout = 0,
  -- help to better identify labels and matches
  use_overlay = false,
  preserve_highlights = true,
  search_scope = "buffer",
  update_search_register = true,
  relative_labels = true,
  stop_on_fail = false,
  inclusive = false,

highlights = {
    SjFocusedLabel = { bold = false, italic = false, fg = "#FFFFFF", bg = "#C000C0", },
    SjLabel =        { bold = true , italic = false, fg = "#000000", bg = "#5AA5DE", },
    SjLimitReached = { bold = true , italic = false, fg = "#000000", bg = "#DE945A", },
    SjMatches =      { bold = false, italic = false, fg = "#DDDDDD", bg = "#005080", },
    SjNoMatches =    { bold = false, italic = false, fg = "#DE945A",                 },
    SjOverlay =      { bold = false, italic = false, fg = "#345576",                 },
  },
})
vim.keymap.set({ "n", "x", "o" }, "/", function()
  sj.run({
    prompt_prefix = "/",
  })
  vim.opt.hls=true
end, { desc = "SJ forward" })
vim.keymap.set({ "n", "x", "o" }, "<leader>/", function()
  sj.redo({
    prompt_prefix = "/",
    separator = ""
  })
end, { desc = "SJ forward" })

vim.keymap.set({ "n", "x", "o" }, "?", function()
  sj.run({
    forward_search = false,
    prompt_prefix = "?",
  })
  vim.opt.hls=true
end, { desc = "SJ backward" })
vim.keymap.set({ "n", "x", "o" }, "<leader>?", function()
  sj.redo({
    forward_search = false,
    prompt_prefix = "?",
    separator = ""
  })
end, { desc = "SJ backward" })
