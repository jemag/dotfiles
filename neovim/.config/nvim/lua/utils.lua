local M = {}
function M.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command('augroup '..group_name)
		vim.api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			-- if type(def) == 'table' and type(def[#def]) == 'function' then
			--	def[#def] = lua_callback(def[#def])
			-- end
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command('augroup END')
	end
end

function M.get_system_name()
  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end
  return system_name
end

function M.map_key(type, key, value)
  vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true})
end

return M
