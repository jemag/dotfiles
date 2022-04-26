require("project_nvim").setup({
  show_hidden = true,
  manual_mode = true,
  ignore_lsp = {"terraformls", "tflint"},
  silent_chdir = false,
})
require('telescope').load_extension('projects')
