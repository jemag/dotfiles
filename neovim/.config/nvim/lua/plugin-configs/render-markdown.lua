require("render-markdown").setup({
  code = {
    -- Turn on / off code block & inline code rendering
    enabled = true,
    -- Turn on / off any sign column related rendering
    sign = true,
    -- Determines how code blocks & inline code are rendered:
    --  none: disables all rendering
    --  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
    --  language: adds language icon to sign column if enabled and icon + name above code blocks
    --  full: normal + language
    style = "full",
    -- Amount of padding to add to the left of code blocks
    left_pad = 1,
    -- Amount of padding to add to the right of code blocks when width is 'block'
    right_pad = 1,
    -- Width of the code block background:
    --  block: width of the code block
    --  full: full width of the window
    width = "block",
    -- Determins how the top / bottom of code block are rendered:
    --  thick: use the same highlight as the code body
    --  thin: when lines are empty overlay the above & below icons
    border = "thin",
  },
})
vim.keymap.set("n", "<localleader>tmv", require("render-markdown").toggle, { desc = "Toggle markdown render" })
