require("mason").setup({
  registries = {
    "github:nvim-java/mason-registry",
    "github:mason-org/mason-registry",
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})
