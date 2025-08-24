require("csvview").setup({
  parser = { comments = { "#", "//" } },
  keymaps = {
    -- Text objects for selecting fields
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    -- Excel-like navigation:
    -- Use <Tab> and <S-Tab> to move horizontally between fields.
    -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
  },
})
