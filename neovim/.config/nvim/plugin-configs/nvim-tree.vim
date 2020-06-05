let g:lua_tree_auto_close = 1
nnoremap <silent> <Leader>e
      \ :<C-u>LuaTreeRefresh<CR>
      \ :<C-u>LuaTreeToggle<CR>
nnoremap <silent> <Leader>lr :LuaTreeRefresh<CR>
nnoremap <silent> <Leader>ls :LuaTreeFindFile<CR>
let g:lua_tree_bindings = {
    \ 'edit':        '<CR>',
    \ 'edit_vsplit': '<C-v>',
    \ 'edit_split':  '<C-x>',
    \ 'edit_tab':    '<C-t>',
    \ 'cd':          '.',
    \ 'create':      'a',
    \ 'remove':      'd',
    \ 'rename':      'r'
    \ }
