require("stickybuf").setup({
  -- 'bufnr' will pin the exact buffer (PinBuffer)
  -- 'buftype' will pin the buffer type (PinBuftype)
  -- 'filetype' will pin the filetype (PinFiletype)
  get_auto_pin = function(bufnr)

    local buftype = vim.bo[bufnr].buftype
    local filetype = vim.bo[bufnr].filetype
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if buftype == "help" or buftype == "quickfix" then
      return "buftype"
    elseif buftype == "prompt" then
      return "bufnr"
    elseif
      filetype == "aerial"
      or filetype == "nerdtree"
      or filetype == "neotest-summary"
      or filetype == "vista_kind"
      or filetype == "neo-tree"
      or filetype == "Fyler"
    then
      return "filetype"
    elseif bufname:match("Neogit.*Popup") then
      return "bufnr"
    elseif filetype == "defx" and (vim.wo.winfixwidth or vim.wo.winfixheight) then
      -- Only pin defx if it was opened as a split (has fixed height/width)
      return "filetype"
    elseif filetype == "fern" and (vim.wo.winfixwidth or vim.wo.winfixheight) then
      -- Only pin fern if it was opened as a split (has fixed height/width)
      return "filetype"
    elseif filetype == "NeogitStatus" or filetype == "NeogitLog" or filetype == "NeogitGitCommandHistory" then
      if vim.fn.winnr("$") > 1 then
        return "filetype"
      end
    end
  end,
})
