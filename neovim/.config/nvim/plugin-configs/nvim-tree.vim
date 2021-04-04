nnoremap <Leader>e :NvimTreeToggle<CR>
nnoremap <silent> <Leader>E :NvimTreeFindFile<CR>
" let g:nvim_tree_bindings = {
"     \ 'edit':            ['<CR>', 'o'],
"     \ 'edit_vsplit':     '<C-v>',
"     \ 'edit_split':      '<C-x>',
"     \ 'edit_tab':        '<C-t>',
"     \ 'close_node':      ['<S-CR>', '<BS>'],
"     \ 'toggle_ignored':  'I',
"     \ 'toggle_dotfiles': 'H',
"     \ 'refresh':         'R',
"     \ 'preview':         '<Tab>',
"     \ 'cd':              '<C-]>',
"     \ 'create':          'a',
"     \ 'remove':          'd',
"     \ 'rename':          'r',
"     \ 'cut':             'x',
"     \ 'copy':            'c',
"     \ 'paste':           'p',
"     \ 'prev_git_item':   '[c',
"     \ 'next_git_item':   ']c',
"     \ }
let g:nvim_tree_width = 65
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
