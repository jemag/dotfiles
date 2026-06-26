return {
 settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.format({ range = { start = { 0, 0 }, ["end"] = { vim.fn.line "$", 0 } } })
        end,
      },
    },
  },
}
