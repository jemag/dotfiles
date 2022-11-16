require("bqf").setup({
  preview = {
    auto_preview = false,
  },
  filter = {
    fzf = {
      extra_opts = { "--bind", "ctrl-e:toggle-all" },
    },
  },
  func_map = {
    open = "<cr>",
    openc = "o",
    drop = "O",
    -- tabdrop     =
    tab = "t",
    tabb = "T",
    tabc = "<C-t>",
    split = "<C-x>",
    vsplit = "<C-v>",
    prevfile = "<C-p>",
    nextfile = "<C-n>",
    prevhist = "<",
    nexthist = ">",
    lastleave = [['"]],
    stoggleup = "<S-Tab>",
    stoggledown = "<Tab>",
    stogglevm = "<Tab>",
    stogglebuf = "'<Tab>",
    sclear = "z<Tab>",
    pscrollup = "<C-u>",
    pscrolldown = "<C-d>",
    pscrollorig = "zo",
    -- toggle fullscreen preview
    ptogglemode = "zp",
    -- toggle preview for item
    ptoggleitem = "p",
    -- toggle auto preview
    ptoggleauto = "P",
    -- create new list for signed items
    filter = "zn",
    -- create new list for non-signed items
    filterr = "zN",
    fzffilter = "zf",
  },
})
