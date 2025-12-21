vim.g.vim_json_syntax_conceal = 0

vim.keymap.set("n", "<localleader>jy", function()
  local jsonPath = require("jsonpath").get()
  vim.fn.setreg("+", jsonPath)
  vim.fn.setreg('"', jsonPath)
end, { desc = "copy json path", buffer = true })
