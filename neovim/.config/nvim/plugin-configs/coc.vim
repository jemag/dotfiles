"CoC configlet
let g:coc_snippet_next = '<leader>cx'
let g:coc_status_error_sign = '•'
let g:coc_status_warning_sign = '•'
let g:coc_global_extensions =['coc-html','coc-css','coc-snippets','coc-prettier','coc-eslint','coc-emmet','coc-tsserver','coc-pairs','coc-json','coc-python','coc-imselect','coc-git','coc-emoji','coc-lists','coc-post','coc-stylelint','coc-yaml', 'coc-go', 'coc-angular', 'coc-tslint-plugin', 'coc-java', 'coc-highlight']

autocmd CursorHold * silent call CocActionAsync('highlight')

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


autocmd! CompleteDone * if pumvisible() == 0 && bufname('%') != '[Command Line]' | pclose | endif

" Disable coc suggestions in command window
autocmd FileType vim if bufname('%') == '[Command Line]' | let b:coc_suggest_disable = 1 | endif
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <silent> <C-q> :call <sid>show_documentation()<cr>
" use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" float window scroll
nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
