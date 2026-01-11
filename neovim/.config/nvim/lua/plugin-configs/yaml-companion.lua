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

local cfg = require("yaml-companion").setup({
  -- Add any options here, or leave empty to use the default settings
  -- lspconfig = {
  --   settings = { ... }
  -- },
})
vim.lsp.config("yamlls", cfg)
vim.lsp.enable("yamlls")

vim.keymap.set("n", "<localleader>yg", function()
  print_schema_name()
end, { desc = "get json/yaml schema name" })

vim.keymap.set("n", "<localleader>yd", function()
  require("yaml-companion").open_datree_crd_select()
end, { desc = "datree schema modeline" })

vim.keymap.set("n", "<localleader>yp", function()
  require("yaml-companion").add_crd_modelines(0, { dry_run = true })
end, { desc = "preview crd modeline auto-configuration" })

vim.keymap.set("n", "<localleader>ya", function()
  require("yaml-companion").add_crd_modelines()
end, { desc = "crd modeline auto-configuration" })

vim.keymap.set("n", "<localleader>yS", function()
  require("yaml-companion").open_ui_select()
end, { desc = "set yaml schema" })
