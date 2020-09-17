autoload bashcompinit && bashcompinit
source '/home/jemag/.config/zsh/plugins/zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
(( ${+_comps} )) && _comps[zplugin]=_zplugin


###########
# aliases
###########
alias ls="exa -g"
alias grep="grep --color"
alias tp="tmuxinator-fzf-start.sh"
alias ll="ls -l"
alias la="ls -la"
alias lh="ls -lh"
alias lb="br -dsp"
alias ta="tmux attach -t"
alias k="kubectl"
alias vim="nvim"
alias jd="joplin --profile ~/.config/joplin-desktop"
alias tf="terraform"
alias vifm="vifmrun"
alias g="git"
alias tmuxa="tmux attach -t"
alias kcx="kubectx"
alias kns="kubens"
alias kb="kubie"
alias ..="cd .."
alias cat="bat"
alias ac="argocd"
alias d="devour"
tmuxpopup() {
  LBUFFER+=${$(fd --type f --follow --hidden --exclude .git --exclude node_modules | fzf-tmux-popup --preview 'bat --style=numbers --color=always --line-range :500 {}')}
}
zle -N tmuxpopup
bindkey '^[t' tmuxpopup
##########
# generic options
##########
HISTFILE=~/.zsh/zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1				# all search results returned will be unique
setopt INC_APPEND_HISTORY					            # add commmand to history as soon as it's entered
# setopt SHARE_HISTORY
setopt EXTENDED_HISTORY									# save command timestamp
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS                        		# don't write duplicate entries in the history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE                        		# prefix commands you don't want stored with a space
setopt NO_HUP											# don't kill jobs
setopt NO_CHECK_JOBS
setopt autocd
setopt IGNOREEOF
unsetopt rm_star_silent					            # ask for confirmation for `rm *' or `rm path/*'
# Include hidden files in autocomplete:
_comp_options+=(globdots)

##########
# zplugins
##########
zplugin ice wait"2" lucid
zplugin light "hlissner/zsh-autopair"
zplugin ice wait"2" lucid
zplugin light "changyuheng/zsh-interactive-cd"
# zplugin load "denysdovhan/spaceship-prompt"
zplugin ice wait"0" blockf lucid
zplugin light "zsh-users/zsh-completions"
zplugin ice wait'0' atload'_zsh_autosuggest_start' lucid
zplugin light "zsh-users/zsh-autosuggestions"
zplugin snippet /home/jemag/lib/azure-cli/az.completion
zplugin snippet OMZ::lib/git.zsh
zplugin snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh
# Syntax Highlighting (should always be at the end)
zplugin ice wait"0" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting
# zplugin snippet ~/.config/zsh/plugins/fzf/key-bindings.zsh


#########
# spaceship settings
#########
# spaceship_vi_mode_enable()
# SPACESHIP_VI_MODE_SHOW=true

#########
# vim mode settings
########
typeset -A key
key=(
  BackSpace  "${terminfo[kbs]}"
  Home       "${terminfo[khome]}"
  End        "${terminfo[kend]}"
  Insert     "${terminfo[kich1]}"
  Delete     "${terminfo[kdch1]}"
  Up         "${terminfo[kcuu1]}"
  Down       "${terminfo[kcud1]}"
  Left       "${terminfo[kcub1]}"
  Right      "${terminfo[kcuf1]}"
  PageUp     "${terminfo[kpp]}"
  PageDown   "${terminfo[knp]}"
)

# Setup key accordingly
[[ -n "${key[BackSpace]}" ]] && bindkey "${key[BackSpace]}" backward-delete-char
[[ -n "${key[Home]}"      ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey "${key[End]}" end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}"    ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Up]}"        ]] && bindkey "${key[Up]}" up-line-or-beginning-search
[[ -n "${key[Down]}"      ]] && bindkey "${key[Down]}" down-line-or-beginning-search
[[ -n "${key[PageUp]}"    ]] && bindkey "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history
[[ -n "${key[Home]}"      ]] && bindkey -M vicmd "${key[Home]}" beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -M vicmd "${key[End]}" end-of-line
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
bindkey -v
bindkey 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward
# Use vim keys in tab complete menu:
zstyle ':completion:*' menu select
zmodload zsh/complist
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -v '^?' backward-delete-char

#########
# keybinds
#########
bindkey '^f' autosuggest-accept
bindkey -s '^x' 'fg\n'

# remove lines from history with this function
histrm() { LC_ALL=C sed --in-place '/$1/d' $HISTFILE }

# add to path
path+=/root/.gem/ruby/2.5.0/bin
path+=('/home/jemag/bin/')
path+=('/home/jemag/go/bin')
path+=('/snap/bin/')
path+=('/var/lib/snapd/snap/bin')
path+=$GRAILS_HOME/bin

# Source fzf
# Requires installation of fzf
# fzf wiki https://github.com/junegunn/fzf/wiki/examples
#
# Also for this setup, installation of fd and ripgrep
# More on fd https://github.com/sharkdp/fd
# More on ripgrep https://github.com/BurntSushi/ripgrep
# More on these tools https://bluz71.github.io/2018/06/07/ripgrep-fd-command-line-search-tools.html
#
[ -f ~/.config/zsh/plugins/fzf/key-bindings.zsh ] && source ~/.config/zsh/plugins/fzf/key-bindings.zsh
export FZF_DEFAULT_OPS="
--extended
"
FD_OPTIONS="--follow --hidden --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --type f $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
    --height 50% -1 --layout=reverse --multi --inline-info
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    "
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export JAVA_HOME=/usr/lib/jvm/default
export TERMINAL=/usr/local/bin/st
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export CHROME_BIN=/usr/bin/chromium
export EDITOR=nvim
export GRAILS_HOME=/home/jemag/bin/grails-2.4.4
export PATH
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export PATH=$PATH:/home/jemag/.gem/ruby/2.7.0/bin
export PATH=$PATH:/home/jemag/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export RPS1="$(vi_mode_prompt_info)"
source /home/jemag/.config/broot/launcher/bash/br
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(direnv hook zsh)"
source '/usr/share/nvm/init-nvm.sh'
eval "$(starship init zsh)"
