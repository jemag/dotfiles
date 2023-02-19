require("nvim-lastplace").setup({
    lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" , "floaterm"},
    lastplace_open_folds = true,
})
