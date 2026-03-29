require("tf-docs").setup({
  win_config = {
    split = "right",
  },
  providers = {
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
  },
})
