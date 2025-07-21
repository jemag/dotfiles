local M = {}

function Start_jdt()
  local config = require("lsp.jdtls-config").get_config()
  require("jdtls").start_or_attach(config)
end

M.setup = function()
  vim.api.nvim_create_autocmd({ "FileType"}, {
    pattern = "java",
    callback = function()
      Start_jdt()
    end,
    desc = "Start java language server"
  })
end

return M
