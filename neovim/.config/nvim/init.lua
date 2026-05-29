if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end
vim.g.mapleader = " "
vim.cmd([[ let maplocalleader = "\<bs>"]])
require("filetypes")
require("json-yaml")
-- To disable smart_splits multiplexer integration
vim.g.smart_splits_multiplexer_integration = false
require("plugins")
require("keybindings")
require("globals")
require("marks")

vim.opt.exrc = true
vim.opt.secure = true
-- Restore cursor to last position in buffer (replaces archived ethanholz/nvim-lastplace)
local lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" }
local lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", "floaterm" }

local function restore_cursor()
  if vim.tbl_contains(lastplace_ignore_buftype, vim.bo.buftype) then
    return
  end
  if vim.tbl_contains(lastplace_ignore_filetype, vim.bo.filetype) then
    return
  end
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  local line_count = vim.api.nvim_buf_line_count(0)
  if mark[1] > 0 and mark[1] <= line_count then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
    pcall(vim.cmd, "normal! zz")
  end
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("lastplace", { clear = true }),
  callback = restore_cursor,
})

vim.schedule(function()
  local workspace_path = vim.fn.getcwd()
  local cache_dir = vim.fn.stdpath("data")
  local unique_id = vim.fn.fnamemodify(workspace_path, ":t") .. "_" .. vim.fn.sha256(workspace_path):sub(1, 8) ---@type string
  local shadafile = cache_dir .. "/myshada/" .. unique_id .. ".shada"
  vim.opt.shadafile = shadafile
  pcall(vim.cmd, "rshada!")
  restore_cursor()
end)

require("settings")

-- function to do continuous horizontal scrolling
vim.cmd([[
function! HorizontalScrollMode( call_char )
  if &wrap
    return
  endif

  echohl Title
  let typed_char = a:call_char
  while index( [ 'h', 'l', 'H', 'L' ], typed_char ) != -1
    execute 'normal! z'.typed_char
    redraws
    echo '-- Horizontal scrolling mode (h/l/H/L)'
    let typed_char = nr2char(getchar())
  endwhile
  echohl None | echo '' | redraws
endfunction
]])
vim.api.nvim_create_augroup("cmdwin_esc", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    vim.keymap.set("n", "<esc>", "<c-c><c-c>", { buffer = true })
  end,
  group = "cmdwin_esc",
  desc = "Use Esc to exit command-line window",
})
-- Resetting these keymaps since their normal behaviour do not work in the command-line window
vim.api.nvim_create_augroup("cmdwin_reset_maps", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    vim.keymap.set("n", "<c-n>", "<c-n>", { buffer = true })
    vim.keymap.set("n", "<c-p>", "<c-p>", { buffer = true })
    vim.keymap.set("n", "<up>", "<up>", { buffer = true })
    vim.keymap.set("n", "<down>", "<down>", { buffer = true })
    vim.keymap.set("n", "<left>", "<left>", { buffer = true })
    vim.keymap.set("n", "<right>", "<right>", { buffer = true })
    vim.keymap.set("n", "<cr>", "<cr>", { buffer = true })
  end,
  group = "cmdwin_reset_maps",
  desc = "Remove some keybinds for command-line window",
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Automatically split help buffers to the right",
  pattern = { "help", "man" },
  command = "wincmd L",
})

vim.cmd("filetype indent plugin on")
