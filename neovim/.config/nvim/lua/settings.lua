vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.confirm = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.wildmode = "full"
vim.opt.inccommand = "split"
vim.opt.textwidth = 0
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.mouse = "a"
vim.opt.laststatus = 2
vim.opt.fillchars = {
	diff = "∙", -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
	eob = " ", -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
	fold = "·", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
	vert = "┃", -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
}
vim.opt.ruler = false
vim.opt.showtabline = 2

vim.opt.spelllang = { "en", "fr" }
vim.opt.history = 2000
vim.opt.number = true
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.cmdheight = 1
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 100
vim.opt.undofile = true
-- TODO: replace with some home directory expansion thing
vim.opt.undodir = "/home/jemag/.tmp/undo"
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
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.showbreak = "↳ " -- DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
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
local autocmds = {
	highlight_yank = {
		{
			"TextYankPost",
			"*",
			"silent! lua vim.highlight.on_yank {higroup='Substitute', on_visual=false, timeout=200}",
		},
	},
}
require("utils").nvim_create_augroups(autocmds)
