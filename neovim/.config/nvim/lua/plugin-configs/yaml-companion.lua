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
vim.keymap.set("n", "<localleader>yS", "<cmd>Telescope yaml_schema<cr>", { desc = "set json/yaml schema" })
vim.keymap.set("n", "<localleader>ys", "<cmd>YAMLTelescope<cr>", { desc = "Search yaml" })
