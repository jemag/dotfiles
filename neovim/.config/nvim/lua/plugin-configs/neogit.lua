local neogit = require("neogit")

neogit.setup({
  auto_refresh = true,
  -- customize displayed signs
  integrations = {
    diffview = true,
    telescope = false,
    snacks = true,
  },
  disable_line_numbers = false,
  disable_relative_line_numbers = false,
  mappings = {
    popup = {
      ["g?"] = "HelpPopup",
      ["?"] = false,
    },
    status = {
      ["1"] = false,
      ["2"] = false,
      ["3"] = false,
      ["4"] = false,
    },
  },
})
