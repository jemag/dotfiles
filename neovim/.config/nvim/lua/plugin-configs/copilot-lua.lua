require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = false,
    debounce = 75,
    keymap = {
      accept = "<c-f>",
      accept_word = false,
      accept_line = false,
      next = "<TAB>",
      prev = "<S-TAB>",
      dismiss = "<C-]>",
    },
  },
  nes = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept_and_goto = false,
      accept = false,
      dismiss = false,
    },
  },
})
