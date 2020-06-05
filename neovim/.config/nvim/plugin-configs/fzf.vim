let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.cache/dein/repos/github.com/junegunn/fzf.vim/bin/preview.sh {}']}, <bang>0)"autocmd! FileType fzf
