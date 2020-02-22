" Plugin key settings

if dein#tap('denite.nvim')
        nnoremap <silent><LocalLeader>m :<C-u>Denite menu<CR>

        noremap zl :<C-u>call <SID>my_denite_outline(&filetype)<CR>
        noremap zL :<C-u>call <SID>my_denite_decls(&filetype)<CR>
        noremap zT :<C-u>call <SID>my_denite_file_rec_goroot()<CR>

        nnoremap <silent> <LocalLeader>gl :<C-u>Denite gitlog:all<CR>
	    nnoremap <silent> <LocalLeader>gh :<C-u>Denite gitbranch<CR>
endif
function! s:my_denite_outline(filetype) abort
  execute 'Denite' a:filetype ==# 'go' ? "decls:'%:p'" : 'outline'
endfunction
function! s:my_denite_decls(filetype) abort
  if a:filetype ==# 'go'
    Denite decls
  else
    call denite#util#print_error('decls does not support filetypes except go')
  endif
endfunction
function! s:my_denite_file_rec_goroot() abort
  if !executable('go')
    call denite#util#print_error('`go` executable not found')
    return
  endif
  let out = system('go env | grep ''^GOROOT='' | cut -d\" -f2')
  let goroot = substitute(out, '\n', '', '')
  call denite#start(
        \ [{'name': 'file/rec', 'args': [goroot]}],
        \ {'input': '.go'})
endfunction

if dein#tap('coc.nvim')
        " Using CocList
        " Show all diagnostics
        nnoremap <silent> <leader>cd  :<C-u>CocList diagnostics<cr>
        " Manage extensions
        nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
        " Show commands
        nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
        " Find symbol of current document
        nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
        " Search workspace symbols
        nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
        " Resume latest coc list
        nnoremap <silent> <leader>cr  :<C-u>CocListResume<CR>
        " Use `[c` and `]c` for navigate diagnostics
        nmap <silent> [c <Plug>(coc-diagnostic-prev)
        nmap <silent> ]c <Plug>(coc-diagnostic-next)
        " Remap for rename current word
        nmap <leader>rn <Plug>(coc-rename)
        " Remap for format selected region
        vmap <leader>cf  <Plug>(coc-format-selected)
        nmap <leader>cf  <Plug>(coc-format-selected)
        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>ca  <Plug>(coc-codeaction-selected)
        nmap <leader>ca  <Plug>(coc-codeaction-selected)
        " Remap for do codeAction of current line
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)
        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        " Use K for show documentation in preview window
        nnoremap <silent> <C-q> :call <sid>show_documentation()<cr>
        " use <c-space> for trigger completion.
        inoremap <silent><expr> <c-space> coc#refresh()
        nmap [g <Plug>(coc-git-prevchunk)
        nmap ]g <Plug>(coc-git-nextchunk)
        " show chunk diff at current position
        nmap gs <Plug>(coc-git-chunkinfo)
        nnoremap <silent> <leader>cg  :<C-u>CocList --normal gstatus<CR>
        " float window scroll
		nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
		nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

if dein#tap('fzf-preview.vim')
        nnoremap <silent> <leader>ft :FzfPreviewBufferTags <CR>
        nnoremap <silent> <leader>fc :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
        nnoremap <silent> <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
        nnoremap <silent> <leader>fb :FzfPreviewBuffers<CR>
        nnoremap <silent> <leader>ff :FzfPreviewProjectFiles <CR>
        nnoremap <silent> <leader>fd :FzfPreviewDirectoryFiles <CR>
        nnoremap <silent> <leader>fg :FzfPreviewGitStatus <CR>
        nnoremap <silent> <leader>fr :<C-u>FzfPreviewProjectGrep -fzf-arg=--nth=3<CR>
        nnoremap <silent> <leader>fm :FzfPreviewBookmarks <CR>
        nnoremap <silent> <leader>fq :FzfPreviewQuickFix <CR>
        " nnoremap <silent> <leader>ft :BTags<CR>
        " nnoremap <silent> <leader>fc :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
        " nnoremap <silent> <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
        " nnoremap <silent> <leader>fb :Buffers<CR>
        " nnoremap <silent> <leader>ff :call Fzf_dev()<CR>
        " nnoremap <silent> <leader>fr :Find <CR>
        " nnoremap <silent> <leader>fw :Find <C-R><C-W><CR>
endif

if dein#tap('vim-easy-align')
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endif


if dein#tap('vim-go')
	 nnoremap <silent> <leader>gi :GoImpl<CR>
	 nnoremap <silent> <Leader>gd :GoDescribe<CR>
	 nnoremap <silent> <Leader>gc :GoCallees<CR>
	 nnoremap <silent> <Leader>gC :GoCallers<CR>
	 nnoremap <silent> <Leader>gs :GoCallstack<CR>
endif

if dein#tap('vim-easygit')
	nnoremap <silent> <localleader>gd :Gdiff<CR>
	nnoremap <silent> <localleader>gc :Gcommit<CR>
	nnoremap <silent> <localleader>gb :Gblame<CR>
	nnoremap <silent> <localleader>gB :Gbrowse<CR>
	nnoremap <silent> <localleader>gs :Gstatus<CR>
	nnoremap <silent> <localleader>gp :Gpush<CR>
endif


if dein#tap('vim-mundo')
    nnoremap <silent> <leader>m :MundoToggle<CR>
endif

if dein#tap('vim-choosewin')
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwapStay<CR>
endif

if dein#tap('accelerated-jk')
	nmap <silent>j <Plug>(accelerated_jk_gj)
	nmap <silent>k <Plug>(accelerated_jk_gk)
endif

if dein#tap('comfortable-motion.vim')
    nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
    nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
    nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
    nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
endif

if dein#tap('python_match.vim')
	nmap <buffer> {{ [%
	nmap <buffer> }} ]%
endif

if dein#tap('goyo.vim')
	nnoremap <Leader>G :Goyo<CR>
endif

if dein#tap('defx.nvim')
        nnoremap <silent> <Leader>e
                \ :<C-u>Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>
        "nnoremap <silent> <LocalLeader>a
				"\ :<C-u>Defx -resume -buffer-name=tab`tabpagenr()` -search=`expand('%:p')`<CR>
endif

if dein#tap('nerdtree')
        "nerdtree
        nnoremap <silent><localleader>e :NERDTreeToggle <CR>
endif

if dein#tap('vim-startify')
    nnoremap <silent> <leader>s :Startify<CR>
endif

if dein#tap('vim-quickrun')
    nnoremap <silent> <localleader>r :QuickRun<CR>
endif

if dein#tap('dash.vim')
        nnoremap <silent><leader>d :Dash<CR>
endif

if dein#tap('vim-expand-region')
        xmap v <Plug>(expand_region_expand)
        xmap V <Plug>(expand_region_shrink)
endif

if dein#tap('splitjoin.vim')
        let g:splitjoin_join_mapping = ''
        let g:splitjoin_split_mapping = ''
        nmap sj :SplitjoinJoin<CR>
        nmap sk :SplitjoinSplit<CR>
endif

if dein#tap('vista.vim')
        nnoremap <silent><localleader>v :Vista!!<CR>
        nnoremap <silent><leader>fv     :Vista finder coc<CR>
endif

if dein#tap('tagbar')
        nnoremap <silent><localleader>t :TagbarToggle<CR>
endif

if dein#tap('ale')
        nmap [a <Plug>(ale_next_wrap)
        nmap ]a <Plug>(ale_previous_wrap)
endif

" if dein#tap('vim-which-key')
" 		nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" 		nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>
" 		nnoremap <silent>[              :<c-u>WhichKey  '['<CR>
" 		nnoremap <silent>]              :<c-u>WhichKey  ']'<CR>
" endif

if dein#tap('vim-smartchr')
    inoremap <expr> , smartchr#one_of(', ', ',')
    augroup MyAutoCmd
        autocmd FileType go inoremap <buffer><expr> ;
            \ smartchr#loop(':=',';')
        autocmd FileType go inoremap <buffer> <expr> .
          \ smartchr#loop('.', '->', '<-','...')
    augroup end
endif

if dein#tap('vim-textobj-multiblock')
	omap <silent> ab <Plug>(textobj-multiblock-a)
	omap <silent> ib <Plug>(textobj-multiblock-i)
	xmap <silent> ab <Plug>(textobj-multiblock-a)
	xmap <silent> ib <Plug>(textobj-multiblock-i)
endif

if dein#tap('neoterm')
  " quickly toggle term
  nnoremap <silent> <leader>tv :vertical botright Ttoggle<cr><C-w>
  nnoremap <silent> <leader>th :botright Ttoggle<cr><C-w>
endif

if dein#tap('vim-sneak')
  nmap s <Plug>Sneak_s
  nmap S <Plug>Sneak_S
endif
