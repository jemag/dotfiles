require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=] }
  }
})
require'cmp'.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
