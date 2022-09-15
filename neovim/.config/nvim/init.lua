vim.g.mapleader = " "
vim.g.maplocalleader = "-"
require("plugins")
require("keybindings")
require("globals")
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1

require("settings")
local guiAugroup = "gui"
vim.api.nvim_create_augroup(guiAugroup, { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter" }, {
  pattern = "*",
  command = "GuiFont! FuraCode Nerd Font Mono:h9",
  desc = "Set gui font",
  group = guiAugroup,
})

local minlines = "minlines"
vim.api.nvim_create_augroup(minlines, { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*?",
  command = "syntax sync minlines=300",
  desc = "Set syntax sync minlines",
  group = minlines,
})

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
vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")
