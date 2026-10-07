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
-- sj fakes a cmdline with one nvim_echo per keystroke; with ui2 + cmdheight=0 each
-- would be a new line in the message float. A shared id updates one message in place.
local function single_echo(fn)
  return function()
    local echo = vim.api.nvim_echo
    vim.api.nvim_echo = function(chunks, history, opts)
      return echo(chunks, history, vim.tbl_extend("force", opts or {}, { id = "sj.prompt" }))
    end
    local ok, err = pcall(fn)
    vim.api.nvim_echo = echo
    if not ok then
      error(err, 0)
    end
  end
end

vim.keymap.set({ "n", "x", "o" }, "/", single_echo(function()
  sj.run({
    prompt_prefix = "/",
  })
  vim.opt.hls=true
end), { desc = "SJ forward" })
vim.keymap.set({ "n", "x", "o" }, "<leader>/", single_echo(function()
  sj.redo({
    prompt_prefix = "/",
    separator = ""
  })
end), { desc = "SJ forward" })

vim.keymap.set({ "n", "x", "o" }, "?", single_echo(function()
  sj.run({
    forward_search = false,
    prompt_prefix = "?",
  })
  vim.opt.hls=true
end), { desc = "SJ backward" })
vim.keymap.set({ "n", "x", "o" }, "<leader>?", single_echo(function()
  sj.redo({
    forward_search = false,
    prompt_prefix = "?",
    separator = ""
  })
end), { desc = "SJ backward" })
