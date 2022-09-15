require('trevj').setup({
  containers = {
    lua = {
      table_constructor = {final_separator = ',', final_end_line = true},
      arguments = {final_separator = false, final_end_line = true},
      parameters = {final_separator = false, final_end_line = true},
    },
  },
})
