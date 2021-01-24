let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_auto_hover = 1
"map <c-p> to manually trigger completion
imap <silent> <c-p> <Plug>(completion_trigger)
