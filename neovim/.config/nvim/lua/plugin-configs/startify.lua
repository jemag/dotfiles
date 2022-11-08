vim.g.startify_padding_left = 40
vim.g.startify_session_dir = "~/.cache/nvim/session"
vim.g.startify_lists = {
	{ type = "files", header = { "   Files" } },
	{ type = "sessions", header = { "   Sessions" } },
	{ type = "bookmarks", header = { "   Bookmarks" } },
}
vim.g.startify_bookmarks = {
	{ c = "~/.config/i3/config" },
	{ i = "~/.config/nvim/init.vim" },
	{ z = "~/.zshrc" },
}
vim.g.startify_session_delete_buffers = 1
vim.g.startify_enable_special = 0
--[[ function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction ]]
vim.g.startify_session_before_save = {
	'echo "Cleaning up before saving.."',
	'lua require("scrollbar").clear()',
}
vim.keymap.set({"n", "x"}, "<leader>,", "<cmd>Startify<cr>", { desc = "Start screen"})
