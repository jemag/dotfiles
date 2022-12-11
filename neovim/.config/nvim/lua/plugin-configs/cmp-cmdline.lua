require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=], max_item_count = 15 },
    { name = 'cmdline_history', max_item_count = 15 },
  }
})
require'cmp'.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
