vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.backupdir = "/home/jemag/.local/state/nvim/backup//,."
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.confirm = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.foldcolumn = "0"
vim.opt.foldenable = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.colorcolumn = "120"
-- TODO: uncomment once officially released by nvim
vim.opt.smoothscroll = true
-- Fix markdown indentation settings (4 spaces with recommendation)
vim.g.markdown_recommended_style = 0
-- vim.opt.splitkeep = "screen"
-- NOTE: can impact performance if enabled
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.wildmode = "full"
vim.opt.inccommand = "split"
vim.opt.textwidth = 0
vim.opt.wrap = false
vim.opt.virtualedit = { "block" }
vim.opt.mouse = "a"
vim.opt.tabclose = "uselast"
vim.opt.mousemodel = "extend"
vim.opt.laststatus = 3
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
-- vim.opt.grepprg = "rg --vimgrep --no-heading --hidden --smart-case --ignore-file ~/dotfiles/fzf-ignore"
vim.opt.grepprg = "rg --vimgrep --no-heading --hidden --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.fillchars = {
  diff = "∙", -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
  eob = " ", -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
  fold = "·", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  foldopen = "", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  foldsep = " ", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  foldclose = "", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  vert = "┃", -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
}
vim.opt.ruler = false
vim.opt.showtabline = 0
vim.g.editorconfig = true
vim.o.smartindent = true

vim.opt.spelllang = { "en", "fr" }
vim.opt.history = 2000
vim.opt.number = true
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.cmdheight = 1
-- Increased timeoutlen value for gx and wslview
vim.opt.timeoutlen = 500
-- keep same scroll view when jumping
vim.opt.jumpoptions = "stack,view"
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 100
vim.opt.undofile = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.hidden = true
vim.opt.shortmess = vim.opt.shortmess + "A" -- ignore annoying swapfile messages
vim.opt.shortmess = vim.opt.shortmess + "I" -- no splash screen
vim.opt.shortmess = vim.opt.shortmess + "O" -- file-read message overwrites previous
vim.opt.shortmess = vim.opt.shortmess + "T" -- truncate non-file messages in middle
vim.opt.shortmess = vim.opt.shortmess + "W" -- don't echo "[w]"/"[written]" when writing
vim.opt.shortmess = vim.opt.shortmess + "a" -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
vim.opt.shortmess = vim.opt.shortmess + "c" -- completion messages
vim.opt.shortmess = vim.opt.shortmess + "o" -- overwrite file-written messages
vim.opt.shortmess = vim.opt.shortmess + "t" -- truncate file messages at start
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.showbreak = "↳ " -- DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
}
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.wildignore = vim.opt.wildignore + "*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*"
vim.opt.conceallevel = 2
vim.opt.diffopt = { "filler", "internal", "closeoff", "hiddenoff", "algorithm:histogram", "linematch:60" }
local cursorlineAugroup = "CursorLineOnlyInActiveWindow"
vim.api.nvim_create_augroup(cursorlineAugroup, { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = cursorlineAugroup,
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = true
  end,
  desc = "Show cursorline in active window",
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = cursorlineAugroup,
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Hide cursorline in inactive window",
})

vim.opt.cpoptions = vim.opt.cpoptions
  - "a" -- Do not put :read file in alternate file
  - "A" -- Do not put :write file in alternate file
  + ">"

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "a" -- Auto formatting is BAD.
      - "t" -- Don't auto format my code. I got linters for that.
      - "o" -- O and o, don't continue comments
      - "2" -- I'm not in gradeschool anymore
      + "c" -- In general, I like it when comments respect textwidth
      + "q" -- Allow formatting comments w/ gq
      - "r" -- But do continue when pressing enter.
      + "n" -- Indent past the formatlistpat, not underneath it.
      + "j" -- Auto-remove comments if possible.
  end,
  desc = "Set format options for all filetypes",
})

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "exe 'tabdo windo clearjumps' | tabnext",
  desc = "Clear jumplist when starting neovim",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Substitute", on_visual = true, timeout = 300 })
  end,
  desc = "Highlight yanked text",
})

local wr_group = vim.api.nvim_create_augroup("WinResize", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = wr_group,
  pattern = "*",
  command = "wincmd =",
  desc = "Automatically resize windows when the host window size changes.",
})

local colorcolumnAugroup = "CursorColumnOnlyInActiveWindow"
vim.api.nvim_create_augroup(colorcolumnAugroup, { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = colorcolumnAugroup,
  pattern = "*",
  callback = function()
    vim.opt_local.colorcolumn = "120"
  end,
  desc = "Show colorcolumn in active window",
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = colorcolumnAugroup,
  pattern = "*",
  callback = function()
    vim.opt_local.colorcolumn = ""
  end,
  desc = "Hide colorcolumn in inactive window",
})

vim.api.nvim_create_user_command(
  "Qa",
  "qa",
  {}
)
