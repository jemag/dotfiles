require("nvim-tree").setup({
  disable_netrw = false,
  hijack_netrw = false,
  open_on_setup = false,
  ignore_ft_on_setup = { "startify", "dashboard" },
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  view = {
    width = 65,
    side = "left",
    mappings = {
      custom_only = false,
      list = {
        { key = "X", cb = ':lua require"nvim-tree.lib".collapse_all()<CR>' },
      },
    },
  },
})
