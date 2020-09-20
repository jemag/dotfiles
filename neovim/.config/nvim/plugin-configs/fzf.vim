let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--inline-info']}), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --glob=!.git --column --line-number --hidden --smart-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--layout=reverse --inline-info --delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--layout=reverse --inline-info --delimiter : --nth 4.. -e'}, 'right:50%', '?'),
  \   <bang>0)
