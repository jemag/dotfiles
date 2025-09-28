local filter_windows = require("utils").filter_windows
local fyler = require("fyler")

fyler.setup({
  track_current_buffer = false,
  close_on_select = false,
  win = {
    kind_presets = {
      float = {
        height = "0.7rel",
        width = "0.7rel",
        top = "0.1rel",
        left = "0.15rel",
      },
      split_left_most = {
        width = "50abs",
      },
    },
  },
  mappings = {
    ["<c-e>"] = function(self)
      local node_entry = self:cursor_node_entry()
      if not node_entry then
        return
      end
      local path = node_entry.path
      local win = require("snacks").picker.util.pick_win({ filter = filter_windows })
      if win ~= nil then
        vim.api.nvim_set_current_win(win)
        vim.cmd("edit " .. path)
      end
    end,
    ["<c-s>"] = function(self)
      local node_entry = self:cursor_node_entry()
      if not node_entry then
        return
      end
      local path = node_entry.path
      local win = require("snacks").picker.util.pick_win({ filter = filter_windows })
      if win ~= nil then
        vim.api.nvim_set_current_win(win)
        vim.cmd("split " .. path)
      end
    end,
    ["<c-v>"] = function(self)
      local node_entry = self:cursor_node_entry()
      if not node_entry then
        return
      end
      local path = node_entry.path
      local win = require("snacks").picker.util.pick_win({ filter = filter_windows })
      if win ~= nil then
        vim.api.nvim_set_current_win(win)
        vim.cmd("vsplit " .. path)
      end
    end,
    ["tf"] = function(self)
      local node_entry = self:cursor_node_entry()
      if not node_entry then
        return
      end
      local path = node_entry.path
      require("snacks").picker.files({ cwd = path })
    end,
    ["tg"] = function(self)
      local node_entry = self:cursor_node_entry()
      if not node_entry then
        return
      end
      local path = node_entry.path
      require("snacks").picker.grep({ cwd = path })
    end,
  },
})
vim.keymap.set({ "n" }, "<localleader>tc", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "Fyler" then
      return vim.api.nvim_win_close(win, false)
    end
  end
end, { desc = "Close Fyler" })
vim.keymap.set({ "n" }, "<leader>e", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "Fyler" then
      return vim.api.nvim_win_close(win, false)
    end
  end
  fyler.open({ kind = "split_left_most" })
end, { desc = "Toggle fyler" })
vim.keymap.set({ "n" }, "<leader>E", function()
  fyler.open({ kind = "split_left_most" })
  fyler.track_buffer()
end, { desc = "Neotree show file" })
