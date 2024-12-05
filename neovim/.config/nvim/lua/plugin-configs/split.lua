require("split").setup({
  keymaps = {
    -- Other keymaps are available :) these ones will be used
    -- by default.
    ["gs"] = {
      pattern = ",",
      operator_pending = true,
      interactive = false,
    },
    ["gss"] = {
      pattern = ",",
      operator_pending = false,
      interactive = false,
    },
    ["gS"] = {
      pattern = ",",
      operator_pending = true,
      interactive = true,
    },
    ["gSS"] = {
      pattern = ",",
      operator_pending = false,
      interactive = true,
    },
  },
})
