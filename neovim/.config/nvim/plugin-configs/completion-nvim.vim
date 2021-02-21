let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_auto_hover = 1
let g:completion_matching_smart_case = 1
"map <c-p> to manually trigger completion
inoremap <silent> <c-Space> <Plug>(completion_trigger)
lua <<EOF
--TODO: Re-read on what this does
vim.g.completion_chain_complete_list = {
    default = {
        {complete_items = {"lsp"}},
        {complete_items = {"snippet"}},
        {complete_items = {"path"}},
        {mode = "<c-n>"},
        {mode = "dict"}
    }
}
EOF
