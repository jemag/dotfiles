if dein#tap('vim-easy-align')
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endif

if dein#tap('vim-choosewin')
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwapStay<CR>
endif

if dein#tap('accelerated-jk')
	nmap <silent>j <Plug>(accelerated_jk_gj)
	nmap <silent>k <Plug>(accelerated_jk_gk)
endif

if dein#tap('indentLine')
  nnoremap <leader>ti :IndentLinesToggle<CR>
endif

" if dein#tap('vim-which-key')
" 		nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" 		nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>
" 		nnoremap <silent>[              :<c-u>WhichKey  '['<CR>
" 		nnoremap <silent>]              :<c-u>WhichKey  ']'<CR>
" endif

if dein#tap('vim-textobj-multiblock')
	omap <silent> ab <Plug>(textobj-multiblock-a)
	omap <silent> ib <Plug>(textobj-multiblock-i)
	xmap <silent> ab <Plug>(textobj-multiblock-a)
	xmap <silent> ib <Plug>(textobj-multiblock-i)
endif


