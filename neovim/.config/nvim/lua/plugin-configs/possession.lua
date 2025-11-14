local Path = require("plenary.path")
require("possession").setup({
  session_dir = (Path:new(vim.fn.stdpath("data")) / "possession"):absolute(),
  prompt_no_cr = true,
  silent = false,
  load_silent = true,
  debug = false,
  hooks = {
    before_save = function(name)
      return {}
    end,
    after_save = function(name, user_data, aborted) end,
    before_load = function(name, user_data)
      for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_delete(buffer, {})
      end
      return user_data
    end,
    after_load = function(name, user_data) end,
  },
  plugins = {
    close_windows = {
      hooks = { "before_save", "before_load" },
      preserve_layout = true, -- or fun(win): boolean
      match = {
        floating = true,
        buftype = {},
        filetype = {},
        custom = false, -- or fun(win): boolean
      },
    },
    delete_hidden_buffers = {
      hooks = {
        "before_load",
      },
      force = false,
    },
    nvim_tree = true,
    tabby = true,
  },
})
vim.keymap.set({ "n" }, "<localleader>pl", "<cmd>PossessionLoadCwd<cr>", { desc = "Load cwd session" })
vim.keymap.set({ "n" }, "<localleader>pL", "<cmd>PossessionLoad<cr>", { desc = "Load session" })
vim.keymap.set("n", "<localleader>pq", "<cmd>PossessionSaveCwd<cr>", { desc = "Quick save" })
vim.keymap.set("n", "<localleader>ps", function()
  local input = vim.fn.input("Save session as: ")
  if input ~= "" then
    vim.cmd("PossessionSave " .. input)
  end
end, { desc = "Save" })
vim.keymap.set("n", "<localleader>pp", "<cmd>PossessionPick<cr>", { desc = "Session pick" })
vim.keymap.set("n", "<localleader>pc", "<cmd>PossessionClose<cr>", { desc = "Session close" })
vim.keymap.set("n", "<localleader>pO", "<cmd>PossessionList<cr>", { desc = "Output all sessions" })
vim.keymap.set("n", "<localleader>po", "<cmd>PossessionListCwd<cr>", { desc = "Output cwd sessions" })
vim.keymap.set("n", "<localleader>pj", "<cmd>SShow<cr>", { desc = "Show session" })
