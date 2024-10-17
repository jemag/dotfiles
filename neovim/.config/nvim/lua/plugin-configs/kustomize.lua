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

vim.keymap.set("n", "<leader>kb", "<cmd>KustomizeBuild<cr>", { noremap = true, desc = "kustomize build" })
vim.keymap.set("n", "<leader>kk", "<cmd>KustomizeListKinds<cr>", { noremap = true, desc = "kustomize kinds" })
vim.keymap.set("n", "<leader>kl", "<cmd>KustomizeListResources<cr>", { noremap = true, desc = "kustomize list resources" })
vim.keymap.set("n", "<leader>kp", "<cmd>KustomizePrintResources<cr>", { noremap = true, desc = "kustomize print resources" })
vim.keymap.set("n", "<leader>kv", "<cmd>KustomizeValidate<cr>", { noremap = true, desc = "kustomize validate" })
vim.keymap.set("n", "<leader>kd", "<cmd>KustomizeDeprecations<cr>", { noremap = true, desc = "kustomize deprecations" })
