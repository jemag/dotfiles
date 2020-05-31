let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']

let g:vista_executive_for = {
  \ 'go': 'ctags',
  \ 'javascript': 'coc',
  \ 'javascript.jsx': 'coc',
  \ 'java': 'coc',
  \ 'python': 'coc',
  \ 'typescript': 'coc',
  \ }
nnoremap <silent><localleader>v :Vista!!<CR>
nnoremap <silent><leader>fv     :Vista finder coc<CR>
