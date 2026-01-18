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
  cluster_crds = {
    enabled = true, -- Enable cluster CRD features
    fallback = true, -- Auto-fallback to cluster when Datree doesn't have schema
    cache_ttl = 86400, -- Cache expiration in seconds (default: 24h, 0 = never expire)
  },
})
vim.lsp.config("yamlls", cfg)
vim.lsp.enable("yamlls")

vim.keymap.set("n", "<localleader>yg", function()
  print_schema_name()
end, { desc = "get json/yaml schema name" })

vim.keymap.set("n", "<localleader>yd", function()
  require("yaml-companion").open_datree_crd_select()
end, { desc = "datree schema modeline" })

vim.keymap.set("n", "<localleader>yC", function()
require("yaml-companion").fetch_cluster_crd(0)
end, { desc = "fetch cluster schema automatically" })

vim.keymap.set("n", "<localleader>yc", function()
require("yaml-companion").open_cluster_crd_select()
end, { desc = "Select schema from cluster" })

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
