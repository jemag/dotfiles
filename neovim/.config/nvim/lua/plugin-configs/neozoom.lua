require("neo-zoom").setup({ -- use the defaults or UNCOMMENT and change any one to overwrite
  left_ratio = 0.2,
  top_ratio = 0.03,
  width_ratio = 0.70,
  height_ratio = 0.9,
  border = 'double',
  exclude_filetypes = {
    'fzf', 'qf', 'dashboard'
  },
  scrolloff_on_zoom = 13, -- offset to the top-border.
})
