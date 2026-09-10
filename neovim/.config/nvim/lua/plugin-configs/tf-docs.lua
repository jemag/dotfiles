-- tf-docs.nvim has no built-in adaptor for the azuredevops provider, so it is
-- declared inline. microsoft/terraform-provider-azuredevops keeps its docs in
-- the legacy layout: website/docs with r/ and d/ subdirectories.
local azuredevops = {
  name = "azuredevops",
  repo_url = "https://github.com/microsoft/terraform-provider-azuredevops.git",
  is_legacy_docs = true,
  search_title = "Terraform AzureDevOps Docs",
  file_extension = ".html.markdown",
}

local provider_list = {
  "azurerm",
  "azuread",
  azuredevops,
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
  -- entries are either a built-in provider name or a custom adaptor table
  local name = type(provider) == "table" and provider.name or provider
  table.insert(provider_snacks, {
    text = name,
    value = name,
    label = name,
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
