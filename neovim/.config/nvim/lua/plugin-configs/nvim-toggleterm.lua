require("toggleterm").setup({
  shading_factor = "0",
  hide_numbers = false,
  direction = "float",
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.5
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end,
})
local term = require("toggleterm.terminal").Terminal

vim.keymap.set("n", "<leader>tc", function()
  local t = term:new({
    dir = "%:p:h",
    display_name = vim.fn.expand("%:p:h"),
  })
  t:toggle()
end, { desc = "Term current dir" })
vim.keymap.set("n", "<leader>tg", function()
  local t = term:new({
    cmd = "lazygit",
    display_name = "lazygit"
  })
  t:toggle()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>tb", function()
  local t = term:new({
    cmd = "btop",
    display_name = "btop"
  })
  t:toggle()
end, { desc = "Btop" })
vim.keymap.set("n", "<leader>td", function()
  local t = term:new({
    cmd = "lazydocker",
    display_name = "lazydocker"
  })
  t:toggle()
end, { desc = "Lazydocker" })
vim.keymap.set("n", "<leader>t;", function()
  local t = term:new({
    display_name = "default"
  })
  t:toggle()
end, { desc = "Create term" })

vim.keymap.set("n", "<leader>ts", "<cmd>Telescope toggleterm_manager<cr>", { desc = "Search terminals" })
vim.keymap.set({ "n", "t" }, "<F9>", "<cmd>ToggleTerm<cr>", { desc = "Toggle term" })
