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


--- Useful for pick_win filtering of windows
---@param win number
---@param buf number
---@return boolean
function M.filter_windows(win, buf)
  local filetype = vim.bo[buf].filetype
  local buftype = vim.bo[buf].buftype
  local excluded_buftypes = { "nofile", "prompt" }
  local excluded_filetypes = { "notify", "neo-tree", "neo-tree-popup", "quickfix", "scrollview", "snacks_picker_preview" }
  for _, item in ipairs(excluded_filetypes) do
    if item == filetype then
      return false
    end
  end
  for _, item in ipairs(excluded_buftypes) do
    if item == buftype then
      return false
    end
  end
  return true
end

--- Creates a temporary split with the given command
---@param split_cmd string  command to use to create the split
---@return integer buffer number
local function create_temp_split(split_cmd)
  vim.cmd(split_cmd)

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  return buf;
end

--- Create a temporary vertical split
---@return integer buffer number
function M.create_temp_vertical_split()
  return create_temp_split("vnew")
end

--- Create a temporary horizontal split
---@return integer buffer number
function M.create_temp_horizontal_split()
  return create_temp_split("new")
end

return M

