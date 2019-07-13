let s:menus = {}

let s:menus.dein = { 'description': ' Plugin management' }
let s:menus.dein.command_candidates = [
  \   [' Dein: Plugins update       ', 'call dein#update()'],
  \   [' Dein: Plugins List         ', 'Denite dein'],
  \   [' Dein: RecacheRuntimePath   ', 'call dein#recache_runtimepath()'],
  \   [' Dein: Update log           ', 'echo dein#get_updates_log()'],
  \   [' Dein: Log                  ', 'echo dein#get_log()'],
  \ ]

let s:menus.project = { 'description': ' Project & Structure' }
let s:menus.project.command_candidates = [
  \   [' File Explorer        <Leader>e',        'Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>'],
  \   [' Outline              <LocalLeader>t',   'TagbarToggle'],
  \   [' Git Status           <LocalLeader>gs',  'Denite gitstatus'],
  \   [' Mundo Tree           <Leader>m',  'MundoToggle'],
  \ ]

let s:menus.files = { 'description': ' File tools' }
let s:menus.files.command_candidates = [
  \   [' Denite: Find in files…     ',  'Denite grep:.'],
  \   [' Denite: Find files         ',  'Denite file/rec'],
  \   [' Denite: Buffers            ',  'Denite buffer'],
  \   [' Denite: MRU                ',  'Denite file/old'],
  \   [' Denite: Line               ',  'Denite line'],
  \ ]

let s:menus.tools = { 'description': ' Dev Tools' }
let s:menus.tools.command_candidates = [
  \   [' Git commands       ', 'Git'],
  \   [' Git log            ', 'Denite gitlog:all'],
  \   [' Goyo               ', 'Goyo'],
  \   [' Tagbar             ', 'TagbarToggle'],
  \   [' File explorer      ', 'Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>'],
  \ ]

let s:menus.config = { 'description': ' Shell Configuration' }
let s:menus.config.file_candidates = [
  \   [' Zsh Configurationfile            ', '~/.zshrc'],
  \   [' Tmux Configurationfile           ', '~/.tmux.conf'],
  \   [' Fish Configurationfile           ', '~/.config/fish/config.fish'],
  \ ]

let s:menus.thinkvim = {'description': ' ThinkVim Configuration files'}
let s:menus.thinkvim.file_candidates = [
  \ [' MainVimrc          settings: vimrc               ', $VIMPATH.'/core/vimrc'],
  \ [' Initial            settings: initialize.vim      ', $VIMPATH.'/core/initialize.vim'],
  \ [' General            settings: general.vim         ', $VIMPATH.'/core/general.vim'],
  \ [' DeinConfig         settings: deinrc.vim          ', $VIMPATH.'/core/deinrc.vim'],
  \ [' FileTypes          settings: filetype.vim        ', $VIMPATH.'/core/filetype.vim'],
  \ [' ColorScheme        settings: theme.vim           ', $VIMPATH.'/core/themes/theme.vim'],
  \ [' Installed       LoadPlugins: plugins.yaml        ', $VIMPATH.'/core/dein/plugins.yaml'],
  \ [' Global   Key    Vimmappings: keymaps.vim         ', $VIMPATH.'/core/keymaps.vim'],
  \ [' Global   Key Pluginmappings: Pluginmappings      ', $VIMPATH.'/core/plugins/allkey.vim'],
  \ ]

call denite#custom#var('menu', 'menus', s:menus)

"let s:menus.sessions = { 'description': 'Sessions' }
"let s:menus.sessions.command_candidates = [
  "\   ['▶ Restore session │ ;s', 'Denite session'],
  "\   ['▶ Save session…   │', 'Denite session/new'],
  "\ ]
