require("stickybuf").setup({
  -- 'bufnr' will pin the exact buffer (PinBuffer)
  -- 'buftype' will pin the buffer type (PinBuftype)
  -- 'filetype' will pin the filetype (PinFiletype)
  filetype = {
    aerial = "filetype",
    nerdtree = "filetype",
    vista_kind = "filetype",
    ['neo-tree'] = "filetype",
    ['neotest-summary'] = "filetype",
  },
})
