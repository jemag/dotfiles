require("bufferline").setup({
  options = {
    numbers = "ordinal",
  },
})

local function close_all_but_current_buffer()
  for _, e in ipairs(require("bufferline").get_elements().elements) do
    vim.schedule(function()
      if e.id == vim.api.nvim_get_current_buf() then
        return
      else
        vim.cmd("bd " .. e.id)
      end
    end)
  end
end

local function close_hidden_buffers()
  local bufinfos = vim.fn.getbufinfo({ buflisted = true }) or {}
  for _, bufinfo in ipairs(bufinfos) do
    if bufinfo.hidden == 1 then
      vim.api.nvim_buf_delete(bufinfo.bufnr, { force = true })
    end
  end
end

local function close_all_but_pinned()
  local bufferline = require("bufferline")
  local commands = require("bufferline.commands")
  local current = vim.api.nvim_get_current_buf()
  vim.schedule(function()
    for _, e in ipairs(bufferline.get_elements().elements) do
      local is_current = e.id == current
      local is_pinned = bufferline.groups._is_pinned(e)
      if not is_current and not is_pinned then
        commands.unpin_and_close(e.id)
      end
    end
  end)
end

vim.keymap.set({ "n", "x" }, "H", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set({ "n", "x" }, "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set({ "n", "x" }, "<leader>1", "<cmd>lua require('bufferline').go_to(1, true)<cr>", { desc = "Buf 1" })
vim.keymap.set({ "n", "x" }, "<leader>2", "<cmd>lua require('bufferline').go_to(2, true)<cr>", { desc = "Buf 2" })
vim.keymap.set({ "n", "x" }, "<leader>3", "<cmd>lua require('bufferline').go_to(3, true)<cr>", { desc = "Buf 3" })
vim.keymap.set({ "n", "x" }, "<leader>4", "<cmd>lua require('bufferline').go_to(4, true)<cr>", { desc = "Buf 4" })
vim.keymap.set({ "n", "x" }, "<leader>5", "<cmd>lua require('bufferline').go_to(5, true)<cr>", { desc = "Buf 5" })
vim.keymap.set({ "n", "x" }, "<leader>6", "<cmd>lua require('bufferline').go_to(6, true)<cr>", { desc = "Buf 6" })
vim.keymap.set({ "n", "x" }, "<leader>7", "<cmd>lua require('bufferline').go_to(7, true)<cr>", { desc = "Buf 7" })
vim.keymap.set({ "n", "x" }, "<leader>8", "<cmd>lua require('bufferline').go_to(8, true)<cr>", { desc = "Buf 8" })
vim.keymap.set({ "n", "x" }, "<leader>9", "<cmd>lua require('bufferline').go_to(9, true)<cr>", { desc = "Buf 9" })
vim.keymap.set({ "n", "x" }, "<leader>0", "<cmd>lua require('bufferline').go_to(10, true)<cr>", { desc = "Buf 10" })
vim.keymap.set({ "n", "x" }, "<leader>bd", "<cmd>bd<cr>", { desc = "Delete-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bD", close_all_but_current_buffer, { desc = "Delete all other buffers" })
vim.keymap.set({ "n", "x" }, "<leader>b$", "<cmd>lua require('bufferline').go_to(-1, true)<cr>", { desc = "Last-buffer" })
vim.keymap.set({ "n", "x" }, "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "move prev" })
vim.keymap.set({ "n", "x" }, "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "move next" })
vim.keymap.set({ "n", "x" }, "<leader>bH", "<cmd>BufferLineCloseLeft<cr>", { desc = "delete buffers to the left" })
vim.keymap.set({ "n", "x" }, "<leader>bL", "<cmd>BufferLineCloseRight<cr>", { desc = "delete buffers to the right" })
vim.keymap.set({ "n", "x" }, "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle buffer pin" })
vim.keymap.set({ "n", "x" }, "<leader>bP", close_all_but_pinned, { desc = "Close all unpinned" })
vim.keymap.set({ "n", "x" }, "<leader>bs", "<cmd>BufferLinePick<cr>", { desc = "Magic buffer select" })
vim.keymap.set({ "n", "x" }, "<leader>bv", close_hidden_buffers, { desc = "Close non-visible buffers" })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    if vim.g.colors_name == "monokai-pro" then
      vim.api.nvim_set_hl(0, "BufferLineNumbers", { link = "BufferLineBackground" })
      vim.api.nvim_set_hl(0, "BufferLineNumbersSelected", { link = "BufferLineBufferSelected" })
      vim.api.nvim_set_hl(0, "BufferLineNumbersVisible", { link = "BufferLineBufferSelected" })
    end
  end,
})
