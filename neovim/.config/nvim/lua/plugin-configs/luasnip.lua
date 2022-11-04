vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-or-jump", { desc = "Expand snip or jump next" })
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-or-jump", { desc = "Expand snip or jump next" })
vim.api.nvim_set_keymap("i", "<C-y>", "<Plug>luasnip-jump-prev", { desc = "Jump previous snip item" })
vim.api.nvim_set_keymap("s", "<C-y>", "<Plug>luasnip-jump-prev", { desc = "Jump previous snip item" })
local ls = require("luasnip")

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
