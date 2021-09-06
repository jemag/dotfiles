vim.api.nvim_exec([[
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
]],true)
vim.g['sneak#label'] = 1
