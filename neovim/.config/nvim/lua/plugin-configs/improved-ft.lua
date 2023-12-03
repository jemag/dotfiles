local ft = require("improved-ft")
ft.setup({
  -- Maps default f/F/t/T/;/, keys
  -- default: false
  use_default_mappings = true,
  -- Ignores case of interactively given characters.
  -- default: false
  -- ignore_user_char_case = true,
  -- Takes a last jump direction into account during repetition jumps.
  -- default: false
  use_relative_repetition = true,
})
