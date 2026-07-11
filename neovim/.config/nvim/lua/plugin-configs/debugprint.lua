require("debugprint").setup({
  highlight_lines = false,
  keymaps = {
    normal = {
      plain_below = "<leader>ddp",
      plain_above = "<leader>ddP",
      variable_below = "<leader>ddv",
      variable_above = "<leader>ddV",
      variable_below_alwaysprompt = nil,
      variable_above_alwaysprompt = nil,
      textobj_below = "<leader>ddo",
      textobj_above = "<leader>ddO",
      toggle_comment_debug_prints = "<leader>ddt",
      delete_debug_prints = "<leader>ddd",
    },
    visual = {
      variable_below = "<leader>ddv",
      variable_above = "<leader>ddV",
    },
  },
  commands = {
    toggle_comment_debug_prints = "ToggleCommentDebugPrints",
    delete_debug_prints = "DeleteDebugPrints",
  },
  -- … Other options
})
