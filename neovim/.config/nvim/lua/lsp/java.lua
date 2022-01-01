local M = {}

function Start_jdt()
  print("jdtls started")
  require("jdtls").start_or_attach(require("lsp.configs.jdtls-conf").get_config())
end

M.setup = function()
  vim.cmd("autocmd FileType java lua Start_jdt()")
end

return M
