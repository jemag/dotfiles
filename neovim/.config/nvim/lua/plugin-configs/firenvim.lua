vim.g.firenvim_config = {
     globalSettings = {
         ["<C-w>"] = 'noop',
         ["<C-n>"] = 'default',
         alt = 'all',
      },
     localSettings = {
         [".*"]= {
             cmdline = 'neovim',
             priority = 0,
             selector = 'textarea',
             takeover = 'never',
         },
     }
 }

--[[ function! s:IsFirenvimActive(event) abort
  if !exists('*nvim_get_chan_info')
    return 0
  endif
  let l:ui = nvim_get_chan_info(a:event.chan)
  return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
      \ l:ui.client.name =~? 'Firenvim'
endfunction

function! OnUIEnter(event) abort
  if s:IsFirenvimActive(a:event)
    set laststatus=0
    set lines=10
    set guifont=FuraCode\ Nerd\ Font\ Mono:h10
    BarbarDisable
  endif
endfunction
autocmd UIEnter * call OnUIEnter(deepcopy(v:event)) ]]

local autocmds = {
	firenvim = {
		{"BufEnter",     "github.com_*.txt",   "set filetype=markdown"};
		{"BufEnter",     "github.com_*.txt",   "set filetype=markdown"};
		{"BufEnter",     "ticktick.com_*.txt",   "set filetype=markdown"};
		{"BufEnter",     "ticktick.com_*.txt",   "set filetype=markdown"};
	};
}
require'utils'.nvim_create_augroups(autocmds);
