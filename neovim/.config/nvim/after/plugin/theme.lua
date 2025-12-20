vim.opt.background = "dark"
vim.cmd.colorscheme("ayu-mirage")

local M = {}

M.colors = {
  white = "#FFFFFF",
  black = "#000000",
  accent = "#FFCC66",
  bg = "#1F2430",
  fg = "#CBCCC6",
  ui = "#707A8C",
  tag = "#5CCFE6",
  func = "#FFD580",
  entity = "#73D0FF",
  string = "#BAE67E",
  regexp = "#95E6CB",
  markup = "#F28779",
  keyword = "#FFA759",
  special = "#FFE6B3",
  comment = "#5C6773",
  constant = "#D4BFFF",
  operator = "#F29E74",
  error = "#FF3333",
  line = "#191E2A",
  panel_bg = "#232834",
  panel_shadow = "#141925",
  panel_border = "#101521",
  gutter_normal = "#404755",
  gutter_active = "#5F687A",
  search = "#D4BFFF",
  selection_bg = "#33415E",
  selection_inactive = "#323A4C",
  selection_border = "#232A4C",
  guide_active = "#576070",
  guide_normal = "#383E4C",
  vcs_added = "#A6CC70",
  vcs_modified = "#77A8D9",
  vcs_removed = "#F27983",
  vcs_added_bg = "#313D37",
  vcs_removed_bg = "#3E373A",
  fg_idle = "#607080",
  warning = "#FFA759",
}

M.icons = {
  array = "[]",
  arrow = "➜",
  a_to_z = "",
  boxed_x = "",
  boolean = "",
  breadcrumb = "»",
  checkmark = "✓",
  calendar = "",
  class = "ﴯ",
  collapsed = "▸",
  color = "",
  constant = "",
  const = "󰏿",
  constructor = "⌘",
  copilot = "",
  codeium = "",
  debug = "",
  enum = "",
  error = "",
  event = "",
  expanded = "▾",
  field = "ﰠ",
  file = "",
  folder = "󰉋",
  folder_closed = "",
  folder_empty = "ﰊ",
  folder_open = "",
  func = "",
  funct = "󰆧",
  info = "",
  interface = "",
  keyword = "廓",
  key = "󰌋",
  lightbulb = "",
  method = "",
  module = "",
  namespace = "󰌗",
  number = "",
  null = "󰟢",
  object = "󰅩",
  onetwothree = "",
  operator = "",
  package = "",
  pencil = "✎",
  plus = "+",
  property = "ﰠ",
  reference = "",
  ruler = "塞",
  snippet = "",
  snip = "",
  string = "󰉿",
  struct = "פּ",
  table = "",
  tabNine = "",
  tag = "",
  typeParameter = "󰊄",
  text = "󰉿",
  variable = "󰀫",
  value = "󰎠",
  warning = "",
  watch = "󰥔",
}

M.border = {
  "╭",
  "─",
  "╮",
  "│",
  "╯",
  "─",
  "╰",
  "│",
}

local function set_default_colors()
  vim.api.nvim_set_hl(0, "Search", { bg = M.colors.search, fg = M.colors.bg })
  vim.api.nvim_set_hl(0, "CurSearch", { bg = M.colors.special, fg = M.colors.bg })
  vim.api.nvim_set_hl(0, "TermCursor", { reverse = true })
  vim.api.nvim_set_hl(0, "LspInlayHint", { bg = M.colors.selection_border })
  vim.api.nvim_set_hl(0, "LineNr", { fg = M.colors.comment })
  vim.cmd("highlight! link NormalFloat Normal")
end

set_default_colors()

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    set_default_colors()
  end,
  desc = "Set default colors",
})

return M
