require("toggleterm").setup({
  shading_factor = "0",
  hide_numbers = false,
  direction = "float",
  start_in_insert = true,
  persist_mode = false,
  on_open = function(t)
    vim.opt_local.relativenumber = true
    vim.fn.timer_start(1, function()
      vim.cmd('startinsert!')
    end)
  end,
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
    display_name = "lazygit",
  })
  t:toggle()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>tb", function()
  local t = term:new({
    cmd = "btop",
    display_name = "btop",
  })
  t:toggle()
end, { desc = "Btop" })
vim.keymap.set("n", "<leader>td", function()
  local t = term:new({
    cmd = "lazydocker",
    display_name = "lazydocker",
  })
  t:toggle()
end, { desc = "Lazydocker" })
vim.keymap.set("n", "<leader>t;", function()
  local t = term:new({
    display_name = "default",
  })
  t:toggle()
end, { desc = "Create term" })

local function get_term_index(current_id, terms)
  local idx
  for i, v in ipairs(terms) do
    if v.id == current_id then
      idx = i
    end
  end
  return idx
end

local function go_prev_term()
  local current_id = vim.b.toggle_number
  if current_id == nil then
    return
  end

  local terms = require("toggleterm.terminal").get_all(true)
  local prev_index

  local index = get_term_index(current_id, terms)
  if index > 1 then
    prev_index = index - 1
  else
    prev_index = #terms
  end
  require("toggleterm").toggle(terms[index].id)
  require("toggleterm").toggle(terms[prev_index].id)
end

local function go_next_term()
  local current_id = vim.b.toggle_number
  if current_id == nil then
    return
  end

  local terms = require("toggleterm.terminal").get_all(true)
  local next_index

  local index = get_term_index(current_id, terms)
  if index == #terms then
    next_index = 1
  else
    next_index = index + 1
  end
  require("toggleterm").toggle(terms[index].id)
  require("toggleterm").toggle(terms[next_index].id)
end

vim.keymap.set("n", "<leader>ts", "<cmd>Telescope toggleterm_manager<cr>", { desc = "Search terminals" })
vim.keymap.set({ "n", "t" }, "<F6>", "<cmd>Telescope toggleterm_manager<cr>", { desc = "Search terminals" })
vim.keymap.set({ "n", "t" }, "<F9>", "<cmd>ToggleTerm<cr>", { desc = "Toggle term" })
vim.keymap.set({ "n", "t" }, "<F8>", function()
  go_next_term()
end, { desc = "Toggle term" })

vim.keymap.set({ "n", "t" }, "<F7>", function()
  go_prev_term()
end, { desc = "Toggle term" })
