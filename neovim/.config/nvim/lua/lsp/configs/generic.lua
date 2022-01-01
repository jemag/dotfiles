local M = {}

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

M.get_config = function()
  return {
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
    handlers = {},
    capabilities = require("lsp.handlers").capabilities,
    on_init = on_init,
    on_attach = require("lsp.handlers").on_attach,
  }
end

return M
