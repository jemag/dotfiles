local winbar = {}

-- vim.api.nvim_set_hl(0, "WinBarSeparator", { fg = "#F29E74" })
-- vim.api.nvim_set_hl(0, "WinBarContent", { fg = "black", bg = "#F29E74" })
vim.api.nvim_set_hl(0, "WinBarSeparator", { fg = "#1F2430" })
vim.api.nvim_set_hl(0, "WinBarContent", { fg = "#626A73", bg = "#1F2430" })

winbar.eval = function()
  if vim.api.nvim_eval_statusline("%f", {})["str"] == "[No Name]" then
    return ""
  end
  return "%#WinBarSeparator#"
    .. ""
    .. "%*"
    .. "%#WinBarContent#"
    .. "%f"
    .. "%*"
    .. "%#WinBarSeparator#"
    .. ""
    .. "%*"
end

return winbar
