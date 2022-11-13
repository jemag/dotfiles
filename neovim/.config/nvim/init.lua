vim.g.ts_highlight_lua = true
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
  command = "GuiFont! FuraMono Nerd Font:h10",
  desc = "Set gui font",
  group = guiAugroup,
})
vim.api.nvim_create_autocmd({ "UIEnter" }, {
  pattern = "*",
  command = "nmap <c-d> <c-d> | nmap <c-u> <c-u>",
  desc = "disable neoscroll in gui",
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
-- Disable treesitter incremental_selection in command window
vim.api.nvim_create_augroup("cmdwin_treesitter", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  command = "TSBufDisable incremental_selection",
  group = "cmdwin_treesitter",
  desc = "Disable treesitter's incremental selection in Command-line window",
})

vim.api.nvim_create_augroup("cmdwin_esc", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    vim.keymap.set("n", "<esc>", "<c-c><c-c>", {buffer = true})
  end,
  group = "cmdwin_esc",
  desc = "Use Esc to exit command-line window",
})
-- Resetting these keymaps since their normal behaviour do not work in the command-line window
vim.api.nvim_create_augroup("cmdwin_reset_maps", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    vim.keymap.set("n", "<c-n>", "<c-n>", { buffer = true})
    vim.keymap.set("n", "<c-p>", "<c-p>", { buffer = true})
    vim.keymap.set("n", "<up>", "<up>", { buffer = true})
    vim.keymap.set("n", "<down>", "<down>", { buffer = true})
    vim.keymap.set("n", "<left>", "<left>", { buffer = true})
    vim.keymap.set("n", "<right>", "<right>", { buffer = true})
  end,
  group = "cmdwin_reset_maps",
  desc = "Remove some keybinds for command-line window",
})
vim.cmd("filetype indent plugin on")
