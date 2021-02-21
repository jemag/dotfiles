" Expand or jump
imap <expr> <M-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<M-n>'
smap <expr> <M-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<M-n>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
