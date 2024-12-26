local snipe = require("snipe")
snipe.setup({
  ui = {
    position = "center"
  },
})

vim.keymap.set({ "n", "x" }, "<c-s>", snipe.open_buffer_menu, { desc = "Snipe buffer menu" })
snipe.ui_select_menu = require("snipe.menu"):new { position = "center" }
snipe.ui_select_menu:add_new_buffer_callback(function (m)
  vim.keymap.set("n", "<esc>", function ()
    m:close()
  end, { nowait = true, buffer = m.buf })
end)
vim.ui.select = snipe.ui_select;
