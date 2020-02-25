
"CoC configlet 
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'
let g:coc_status_error_sign = '•'
let g:coc_status_warning_sign = '•'
let g:coc_global_extensions =['coc-html','coc-css','coc-snippets','coc-prettier','coc-eslint','coc-emmet','coc-tsserver','coc-pairs','coc-json','coc-python','coc-imselect','coc-highlight','coc-git','coc-emoji','coc-lists','coc-post','coc-stylelint','coc-yaml', 'coc-go', 'coc-angular', 'coc-tslint', 'coc-java']

augroup MyAutoCmd
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

