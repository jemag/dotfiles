let g:lua_tree_auto_close = 1
nnoremap <silent> <Leader>e
      \ :<C-u>LuaTreeRefresh<CR>
      \ :<C-u>LuaTreeToggle<CR>
nnoremap <silent> <Leader>lr :LuaTreeRefresh<CR>
nnoremap <silent> <Leader>ls :LuaTreeFindFile<CR>

