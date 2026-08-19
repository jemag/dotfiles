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

-- Workaround for https://github.com/cablecreek/tf-docs.nvim/issues/6
-- TFDocsUnderCursor relies on <cword>, which honours 'iskeyword'. Since we drop
-- "_" from iskeyword globally (settings.lua), "aws_key_pair" is truncated to a
-- single segment and the lookup fails. Restore "_" for the duration of the call.
local cursor = require("tf-docs.cursor")
local orig_lookup = cursor.lookup
cursor.lookup = function(...)
  local saved = vim.bo.iskeyword
  vim.bo.iskeyword = saved .. ",_"
  local ok, err = pcall(orig_lookup, ...)
  vim.bo.iskeyword = saved
  if not ok then
    error(err)
  end
end
vim.keymap.set("n", "<localleader>dtc", "<cmd>TFDocsUnderCursor<cr>", { desc = "Terraform local docs under cursor" })

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
end, { desc = "Terraform local provider docs" })
