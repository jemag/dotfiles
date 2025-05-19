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
local workspace_path = vim.fn.getcwd()
local cache_dir = vim.fn.stdpath("data")
local unique_id = vim.fn.fnamemodify(workspace_path, ":t") .. "_" .. vim.fn.sha256(workspace_path):sub(1, 8) ---@type string
local shadafile = cache_dir .. "/myshada/" .. unique_id .. ".shada"

vim.opt.shadafile = shadafile

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
-- vim.keymap.set("", "<f1>", toggle_profile)

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
	pattern = {"help", "man"},
	command = "wincmd L",
})

vim.cmd("filetype indent plugin on")
