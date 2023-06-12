vim.g.mapleader = " "
vim.g.maplocalleader = "-"
require("filetypes")
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

local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

local function toggle_profile()
  local prof = require("profile")
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start("*")
  end
end
vim.keymap.set("", "<f1>", toggle_profile)

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
