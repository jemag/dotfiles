require("tmux-status").setup(
 {
  window = {
    separator = " | ",
    icon_zoom = "",
    icon_mark = "",
    icon_bell = "",
    icon_mute = "",
    icon_activity = "",
    text = "name",
  },
  session = {
    icon = ""
  },
  datetime = {
    icon = "󱑍",
    format = "%a %d %b %k:%m",
  },
  battery = {
    icon = "󰂎",
  },
  colors = {
    window_active = "#e69875",
    window_inactive = "#859289",
    window_inactive_recent = "#3f5865",
    session = "#a7c080",
    datetime = "#7a8478",
    battery = "#7a8478",
  },
  force_show = false,        -- Force components to be shown regardless of Tmux status
  manage_tmux_status = true, -- Set to false if you do NOT want the plugin to turn Tmux status on/off
}
)
