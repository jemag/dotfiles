local M = {}

function Start_jdt()
  require("jdtls").start_or_attach(require("lsp.jdtls").get_config())
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
