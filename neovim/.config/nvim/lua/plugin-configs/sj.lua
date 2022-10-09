local sj = require("sj")
sj.setup({
  auto_jump = false,
  separator = ";",
  -- help to better identify labels and matches
  use_overlay = false,
  preserve_highlights = true,
  search_scope = "buffer",
  update_search_register = true,
  relative_labels = true,
})
vim.keymap.set({ "n", "x", "o" }, "/", function()
  sj.run({
    prompt_prefix = "/",
  })
end)
vim.keymap.set({ "n", "x", "o" }, "?", function()
  sj.run({
    forward_search = false,
    prompt_prefix = "?",
  })
end)