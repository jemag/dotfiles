local sj = require("sj")
sj.setup({
  auto_jump = false,
  separator = "",
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
end, { desc = "SJ forward" })
vim.keymap.set({ "n", "x", "o" }, "<leader>/", function()
  sj.run({
    prompt_prefix = "/",
    separator = ";"
  })
end, { desc = "SJ forward" })

vim.keymap.set({ "n", "x", "o" }, "?", function()
  sj.run({
    forward_search = false,
    prompt_prefix = "?",
  })
end, { desc = "SJ backward" })
vim.keymap.set({ "n", "x", "o" }, "<leader>?", function()
  sj.run({
    forward_search = false,
    prompt_prefix = "?",
    separator = ";"
  })
end, { desc = "SJ backward" })
