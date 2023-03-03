local custom_ayu_mirage = require("lualine.themes.ayu_mirage")

local function search_cnt()
  local res = vim.fn.searchcount()

  if res.total > 0 then
    return string.format("%s:[%d/%d]", vim.fn.getreg("/"), res.current, res.total)
  else
    return ""
  end
end

local space = {
  function()
    return " "
  end,
}

local fileformat = {
  "fileformat",
  color = { bg = "#b4befe", fg = "#313244" },
  separator = { left = "", right = "" },
}

local modes = {
  "mode",
  fmt = function(str)
    return str:sub(1, 1)
  end,
  color = { bg = "#fab387		", fg = "#1e1e2e" },
  separator = { left = "", right = "" },
}

require("lualine").setup({
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = custom_ayu_mirage,
    component_separators = { "", "" },
    section_separators = { "", "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { modes },
    lualine_b = {
      "branch",
      "diff",
    },
    lualine_c = {
      { "diagnostic-message" },
    },
    lualine_x = {},
    lualine_y = {
      { "encoding", color = { fg = "#5C6773" } },
      fileformat,
      { "filetype", color = { fg = "#5C6773" } },
    },
    lualine_z = {
      { "location", separator = { left = "" } },
      search_cnt,
      { "progress", separator = { right = "" } },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
