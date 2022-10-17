local function get_schema_name()
  print("inside get_schema_name")
  local schema = require("yaml-companion").get_buf_schema(0)
  if schema then
    return schema.result[1].name
  end
  return ""
end

local function print_schema_name()
  print(get_schema_name())
end

vim.keymap.set("n", "<localleader>msn", function()
  print_schema_name()
end, { desc = "get json/yaml schema name" })
vim.keymap.set("n", "<localleader>mss", "<cmd>Telescope yaml_schema<cr>", { desc = "get json/yaml schema name" })
