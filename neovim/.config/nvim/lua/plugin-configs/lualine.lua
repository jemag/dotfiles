-- NOTE: changing theme through telescope will not set proper separator color
local ayu_mirage = require("lualine.themes.ayu_mirage")

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
    theme = ayu_mirage,
    component_separators = { "", "" },
    section_separators = { "", "" },
    disabled_filetypes = {},
    refresh = {
      statusline = 500,
    },
  },
  sections = {
    lualine_a = {
      modes,
    },
    lualine_b = {
      "branch",
      "diff",
      "spelunk",
      {
        require("tmux-status").tmux_session,
        -- cond = require("tmux-status").show,
        separator = { left = "|", right = "|" },
      },
    },
    lualine_c = {

      {
        require("tmux-status").tmux_windows,
        -- function()
        --   local text = require("tmux-status").tmux_render_format("window_index")..":"..require("tmux-status").tmux_render_format("window_name")
        --   return text
        -- end,
        -- cond = require("tmux-status").show,
        padding = { left = 3 },
        separator = { left = "|" },
      },
    },
    lualine_x = {
      {
        "diagnostic-message",
        icons = {
          error = "",
          warn = "",
          info = "",
          hint = "",
        },
      },
    },
    lualine_y = {
      {
        "datetime",
        style = "%Y-%m-%d %R",
        separator = { left = "", right = "" },
        color = { bg = "#F27983", fg = "#1e1e2e" },
      },
      {
        "encoding",
      },
      fileformat,
      { "filetype" },
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
