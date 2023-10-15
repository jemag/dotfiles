local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "<localleader>" },
    { mode = "x", keys = "<localleader>" },
    { mode = "n", keys = "\\" },
    { mode = "x", keys = "\\" },
    { mode = "n", keys = "[" },
    { mode = "x", keys = "[" },
    { mode = "n", keys = "<cr>" },
    { mode = "x", keys = "<cr>" },
    { mode = "n", keys = "]" },
    { mode = "x", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers({
      show_contents = true,
    }),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "n", keys = "<leader>b", desc = "+buffer" },
    { mode = "n", keys = "<leader>d", desc = "+debug" },
    { mode = "n", keys = "<leader>ds", desc = "+step" },
    { mode = "n", keys = "<leader>dt", desc = "+telescope" },
    { mode = "n", keys = "<leader>du", desc = "+dap ui" },
    { mode = "n", keys = "<leader>f", desc = "+format" },
    { mode = "x", keys = "<leader>f", desc = "+format" },
    { mode = "n", keys = "<leader>g", desc = "+git" },
    { mode = "x", keys = "<leader>g", desc = "+git" },
    { mode = "n", keys = "<leader>h", desc = "+hunk" },
    { mode = "x", keys = "<leader>h", desc = "+hunk" },
    { mode = "n", keys = "<leader>i", desc = "+insert" },
    { mode = "x", keys = "<leader>i", desc = "+insert" },
    { mode = "n", keys = "<leader>l", desc = "+language" },
    { mode = "x", keys = "<leader>l", desc = "+language" },
    { mode = "n", keys = "<leader>m", desc = "+bookmarks" },
    { mode = "x", keys = "<leader>m", desc = "+bookmarks" },
    { mode = "n", keys = "<leader>n", desc = "+notes" },
    { mode = "x", keys = "<leader>n", desc = "+notes" },
    { mode = "n", keys = "<leader>o", desc = "+obsidian" },
    { mode = "n", keys = "<leader>r", desc = "+refactor" },
    { mode = "x", keys = "<leader>r", desc = "+refactor" },
    { mode = "n", keys = "<leader>s", desc = "+search" },
    { mode = "x", keys = "<leader>s", desc = "+search" },
    { mode = "n", keys = "<leader>sg", desc = "+git" },
    { mode = "x", keys = "<leader>sg", desc = "+git" },
    { mode = "n", keys = "<leader>t", desc = "+terminal" },
    { mode = "x", keys = "<leader>t", desc = "+terminal" },
    { mode = "n", keys = "<leader>u", desc = "+unique" },
    { mode = "x", keys = "<leader>u", desc = "+unique" },
    { mode = "n", keys = "<leader>w", desc = "+window" },
    { mode = "x", keys = "<leader>w", desc = "+window" },

    { mode = "n", keys = "<localleader>m", desc = "+misc" },
    { mode = "x", keys = "<localleader>m", desc = "+misc" },
    { mode = "n", keys = "<localleader>p", desc = "+project" },
    { mode = "x", keys = "<localleader>p", desc = "+project" },
    { mode = "n", keys = "<localleader>ps", desc = "+session" },
    { mode = "x", keys = "<localleader>ps", desc = "+session" },
    { mode = "n", keys = "<localleader>s", desc = "+misc search" },
    { mode = "x", keys = "<localleader>s", desc = "+misc search" },
    { mode = "n", keys = "<localleader>t", desc = "+project" },
    { mode = "x", keys = "<localleader>t", desc = "+project" },
  },
  window = {
    delay = 500,
    config = {
      width = "auto",
    },
  },
})
-- Disable mini.clue triggers in command window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function ()
    vim.b.miniclue_disable = true
  end,
  desc = "Disable mini.clue triggers in command window",
})
vim.api.nvim_create_autocmd("Filetype", {
  pattern = {"qf", "aerial", "TelescopePrompt"},
  callback = function ()
    vim.b.miniclue_disable = true
  end,
  desc = "Disable mini.clue triggers for various filetypes",
})
