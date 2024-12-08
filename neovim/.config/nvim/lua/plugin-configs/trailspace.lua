require("mini.trailspace").setup({
  only_in_normal_buffers = true,
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "MiniTrailSpace", { link = "ErrorMsg" })
  end,
  desc = "Set MiniTrailspace color",
})

-- Define a command using lua api
vim.api.nvim_create_user_command("WhiteSpaceErase", function() require("mini.trailspace").trim() end, {})
