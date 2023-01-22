require("statuscol").setup({
  setopt = true,
  relculright = true,
  order = "SNFs"
})
-- vim.o.statuscolumn = "%@v:lua.ScFa@%C%T%@v:lua.ScSa@%s%T%@v:lua.ScLa@%{%v:lua.ScLn()%}%{v:lua.ScSp()}%T"
-- statuscolumn=%@v:lua.ScFa@%C%T%@v:lua.ScSa@%s%T%@v:lua.ScLa@%{%v:lua.ScLn()%}%{v:lua.ScSp()}%T
-- statuscolumn=%@v:lua.ScFa@%C%T%@v:lua.ScLa@%s%T@v:lua.ScNa@%=%{v:lua.ScLn()}%T
