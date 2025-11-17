---@diagnostic disable: assign-type-mismatch
local filter_windows = require("utils").filter_windows
local fyler = require("fyler")

fyler.setup({
  views = {
    finder = {
      follow_current_file = false,
      close_on_select = false,
      watcher = {
        enabled = true,
      },
      win = {
        kind = "split_left_most",
        kinds = {
          float = {
            height = "70%",
            width = "70%",
            top = "10%",
            left = "15%",
          },
          split_left_most = {
            width = "20%",
            win_opts = {
              winfixwidth = true,
            },
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
      mappings_opts = {
        nowait = true,
      },
    },
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
  fyler.toggle({ kind = "split_left_most" })
end, { desc = "Toggle fyler" })
vim.keymap.set({ "n" }, "<leader>E", function()
  fyler.open({ kind = "split_left_most" })
  vim.defer_fn(function()
    fyler.track_buffer()
  end, 75)
end, { desc = "Fyler show file" })
