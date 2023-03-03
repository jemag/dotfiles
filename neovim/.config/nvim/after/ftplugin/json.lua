vim.g.vim_json_syntax_conceal = 0

vim.keymap.set("n", "y<C-p>", function()
  vim.fn.setreg("+", require("jsonpath").get())
end, { desc = "copy json path", buffer = true })
