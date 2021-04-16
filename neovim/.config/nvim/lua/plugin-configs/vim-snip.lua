vim.api.nvim_exec([[
imap <expr> <M-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<M-n>'
smap <expr> <M-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<M-n>'
]],true)
