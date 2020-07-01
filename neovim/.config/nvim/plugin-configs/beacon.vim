let g:beacon_ignore_filetypes = ['fzf']
augroup beacon_toggle
  autocmd!
  autocmd CmdwinEnter,CmdlineEnter * let g:beacon_enable=0
  autocmd CmdwinLeave,CmdlineLeave * let g:beacon_enable=1
augroup END
