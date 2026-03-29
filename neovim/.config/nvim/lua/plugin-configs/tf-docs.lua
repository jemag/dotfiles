local provider_list = {
  "azurerm",
  "azuread",
  "null",
  "kubernetes",
  "local",
  "tls",
  "helm",
  "external",
  "dns",
  "random",
  "time",
  "template",
}

local provider_snacks = {}
for _, provider in ipairs(provider_list) do
  table.insert(provider_snacks, {
    text = provider,
    value = provider,
    label = provider,
  })
end

require("tf-docs").setup({
  win_config = {
    split = "right",
  },
  providers = provider_list,
})

local snacks = require("snacks")
vim.keymap.set("n", "<localleader>dtd", function()
  snacks.picker({
    items = provider_snacks,
    layout = { preview = false },
    confirm = function(picker, item)
      picker:close()
      vim.cmd("TFDocs " .. item.value)
    end,
  })
end, { desc = "Terraform provider docs" })
