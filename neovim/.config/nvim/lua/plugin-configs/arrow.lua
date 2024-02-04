require("arrow").setup({
  show_icons = true,
  always_show_path = false,
  separate_by_branch = false, -- Bookmarks will be separated by git branch
  mappings = {
    edit = "e",
    delete_mode = "d",
    clear_all_items = "C",
    toggle = "s",
    open_vertical = "v",
    open_horizontal = "x",
    quit = "q",
  },
  leader_key = "<c-s>",
  global_bookmarks = false, -- if true, arrow will save files globally (ignores separate_by_branch)
})
