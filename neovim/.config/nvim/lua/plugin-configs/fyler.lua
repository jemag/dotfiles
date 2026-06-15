---@diagnostic disable: assign-type-mismatch
local filter_windows = require("utils").filter_windows
local fyler = require("fyler")

fyler.setup({
  follow_current_file = false,
  kind = "split_left_most",
  integrations = {
    icon = "nvim_web_devicons",
  },
  kind_presets = {
    floating = {
      height = "70%",
      width = "70%",
      row = "center",
      col = "center",
    },
    split_left_most = {
      width = 50,
    },
  },
  win_opts = {
    winfixwidth = true,
    relativenumber = true,
  },
  mappings = {
    n = {
      ["-"] = { action = "visit", args = { parent = true } },
      ["."] = { action = "visit", args = { cursor = true } },
      ["<BS>"] = { action = "shrink", args = { parent = true } },
      ["<C-r>"] = { action = "refresh" },
      ["<C-t>"] = { action = "select", args = { tabedit = true } },
      ["<CR>"] = { action = "select" },
      ["="] = { action = "visit" },
      ["g."] = { action = "toggle_ui", args = { "hidden_items" } },
      ["gi"] = { action = "toggle_ui", args = { "indent_guides" } },
      ["q"] = { action = "close" },
      ["<C-e>"] = {
        action = function(self)
          local node_data = require("fyler.finder").parse_cursor_line(self)
          if not node_data then
            return
          end
          local path = node_data.full_path
          local win = require("snacks").picker.util.pick_win({ filter = filter_windows })
          if win ~= nil then
            vim.api.nvim_set_current_win(win)
            vim.cmd("edit " .. vim.fn.fnameescape(path))
          end
        end,
      },
      ["<C-s>"] = {
        action = function(self)
          local node_data = require("fyler.finder").parse_cursor_line(self)
          if not node_data then
            return
          end
          local path = node_data.full_path
          local win = require("snacks").picker.util.pick_win({ filter = filter_windows })
          if win ~= nil then
            vim.api.nvim_set_current_win(win)
            vim.cmd("split " .. vim.fn.fnameescape(path))
          end
        end,
      },
      ["<C-v>"] = {
        action = function(self)
          local node_data = require("fyler.finder").parse_cursor_line(self)
          if not node_data then
            return
          end
          local path = node_data.full_path
          local win = require("snacks").picker.util.pick_win({ filter = filter_windows })
          if win ~= nil then
            vim.api.nvim_set_current_win(win)
            vim.cmd("vsplit " .. vim.fn.fnameescape(path))
          end
        end,
      },
      ["tf"] = {
        action = function(self)
          local node_data = require("fyler.finder").parse_cursor_line(self)
          if not node_data then
            return
          end
          local path = node_data.full_path
          require("snacks").picker.files({ cwd = path })
        end,
      },
      ["tg"] = {
        action = function(self)
          local node_data = require("fyler.finder").parse_cursor_line(self)
          if not node_data then
            return
          end
          local path = node_data.full_path
          require("snacks").picker.grep({ cwd = path })
        end,
      },
    },
  },
})

local finder = require("fyler.finder")

vim.keymap.set({ "n" }, "<localleader>tc", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fyler_finder" then
      return vim.api.nvim_win_close(win, false)
    end
  end
end, { desc = "Close Fyler" })

vim.keymap.set({ "n" }, "<leader>e", function()
  fyler.toggle({ kind = "split_left_most" })
end, { desc = "Toggle fyler" })

vim.keymap.set({ "n" }, "<leader>E", function()
  local filename = vim.api.nvim_buf_get_name(0)
  finder = require("fyler.finder")
  local inst = finder.instance_get_or_nil()
  if inst then
    if inst.win_id and vim.api.nvim_win_is_valid(inst.win_id) then
      vim.api.nvim_set_current_win(inst.win_id)
    end
    inst:follow({ target_path = filename })
  else
    fyler.open({ kind = "split_left_most" })
    vim.defer_fn(function()
      local new_inst = finder.instance_get_or_nil()
      if new_inst then
        new_inst:follow({ target_path = filename })
      end
    end, 25)
  end
end, { desc = "Fyler show file" })
