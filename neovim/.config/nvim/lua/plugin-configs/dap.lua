vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual", numhl = "DiagnosticSignWarn" })
local dap = require("dap")
dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
dap.configurations["lua"] = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}
vim.keymap.set({ "n" }, "<leader>dal", function()
  require("osv").launch({ port = 8086 })
end, { desc = "Launch lua adapter" })
vim.keymap.set({ "n" }, "<leader>dar", require("osv").run_this , { desc = "Run this lua file" })
vim.keymap.set({ "n" }, "<leader>das", function()
  require("osv").stop()
end, { desc = "Stop lua adapter" })
