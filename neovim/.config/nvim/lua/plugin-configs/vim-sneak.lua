vim.api.nvim_exec([[
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
vmap s <Plug>Sneak_s
vmap S <Plug>Sneak_S
vmap f <Plug>Sneak_f
vmap F <Plug>Sneak_F
vmap t <Plug>Sneak_t
vmap T <Plug>Sneak_T
]],true)
vim.g['sneak#label'] = 1
