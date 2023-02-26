local M = {}
function M.get_system_name()
	local system_name
	if vim.fn.has("mac") == 1 then
		system_name = "macOS"
	elseif vim.fn.has("unix") == 1 then
		system_name = "Linux"
	elseif vim.fn.has("win32") == 1 then
		system_name = "Windows"
	else
		print("Unsupported system for sumneko")
	end
	return system_name
end

function M.map_key(type, key, value)
	vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true })
end

function M.windo_restore_win(windo_str)
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd("windo " .. windo_str)
  vim.api.nvim_set_current_win(cur_win)
end

return M
