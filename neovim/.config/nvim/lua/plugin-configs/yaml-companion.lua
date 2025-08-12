local function get_schema_name()
  local schema = require("yaml-companion").get_buf_schema(0)
  if schema then
    return schema.result[1].name
  end
  return ""
end

local function print_schema_name()
  print(get_schema_name())
end

vim.keymap.set("n", "<localleader>yg", function()
  print_schema_name()
end, { desc = "get json/yaml schema name" })
