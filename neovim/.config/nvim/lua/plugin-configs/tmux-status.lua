require("tmux-status").setup({
  window = {
    separator = " | ",
    icon_zoom = "",
    icon_mark = "",
    icon_bell = "",
    icon_mute = "",
    icon_activity = "",
    text = "index_and_name",
  },
  session = {
    icon = "",
  },
  datetime = {
    icon = "󱑍",
    format = "%a %d %b %k:%m",
  },
  battery = {
    icon = "󰂎",
  },
  colors = {
    window_active = {
      fg = "#FFA759",
      bg = "#242b38",
    },
    window_inactive = {
      fg = "#FFD580",
      bg = "#242b38",
    },
    window_inactive_recent = {
      fg = "#5F687A",
      bg = "#242b38",
    },
    session = {
      fg = "#A6CC70",
      bg = "#242b38",
    },
    datetime = {
      fg = "#7a8478",
      bg = "#242b38",
    },
    battery = {
      fg = "#7a8478",
      bg = "#242b38",
    },
  },
  force_show = false, -- Force components to be shown regardless of Tmux status
  manage_tmux_status = false, -- Set to false if you do NOT want the plugin to turn Tmux status on/off
})
