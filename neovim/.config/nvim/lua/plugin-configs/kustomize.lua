require("kustomize").setup({
  enable_key_mappings = false,
  enable_lua_snip = true,
  run = {
    validate = {
      cmd = "kubeconform",
      args = { "--strict", "--ignore-missing-schemas" },
    },
    deprecations = {
      cmd = "kubent",
      args = { "-t", "1.26", "-c=false", "--helm3=false", "-l=error", "-e", "-f" },
    },
    trivy = {
        cmd = "trivy",
        args = { "-q", "config" },
        timeout = 20000,
        },
  },
})
