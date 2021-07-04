require'lightspeed'.setup {
  jump_to_first_match = true,
  jump_on_partial_input_safety_timeout = 400,
  highlight_unique_chars = false,
  grey_out_search_area = true,
  match_only_the_start_of_same_char_seqs = true,
  limit_ft_matches = 5,
  full_inclusive_prefix_key = '<c-x>',
  -- By default, the values of these will be decided at runtime,
  -- based on `jump_to_first_match`
  labels = nil,
  cycle_group_fwd_key = nil,
  cycle_group_bwd_key = nil,
}
function Repeat_ft(reverse)
  local ls = require'lightspeed'
  ls.ft['instant-repeat?'] = true
  ls.ft:to(reverse, ls.ft['prev-t-like?'])
end
vim.api.nvim_set_keymap('n', ';', '<cmd>lua Repeat_ft(false)<cr>',
  {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', ';', '<cmd>lua Repeat_ft(false)<cr>',
  {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ',', '<cmd>lua Repeat_ft(true)<cr>',
  {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', ',', '<cmd>lua Repeat_ft(true)<cr>',
{noremap = true, silent = true})
vim.api.nvim_exec([[
nmap s <Plug>Lightspeed_s
nmap S <Plug>Lightspeed_S
nmap f <Plug>Lightspeed_f
nmap F <Plug>Lightspeed_F
nmap t <Plug>Lightspeed_t
nmap T <Plug>Lightspeed_T
]],true)
