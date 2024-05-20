local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = "Expand snip or jump next" })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = "Jump previous snip item" })

ls.config.setup({
  history = true,
  update_events = "TextChanged, TextChangedI",
})

local function unlink_snippet()
  if
    ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
    and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
    and not require("luasnip").session.jump_active
  then
    require("luasnip").unlink_current()
  end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  pattern = "*",
  callback = unlink_snippet,
  desc = "Unlink snippet when leaving insert mode",
})
