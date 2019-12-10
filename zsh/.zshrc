autoload bashcompinit && bashcompinit
source '/home/jemag/.config/zsh/plugins/zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin


###########
# aliases
###########
alias ll="ls -l"
alias la="ls -la"
alias lh="ls -lh"
alias ta="tmux attach -t"
alias k="kubectl"
alias vim="nvim"

##########
# generic options
##########
HISTFILE=~/.zsh/zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1				# all search results returned will be unique
setopt incappendhistory					            # add commmand to history as soon as it's entered
setopt extendedhistory									# save command timestamp
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS                        		# don't write duplicate entries in the history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE                        		# prefix commands you don't want stored with a space
setopt NO_HUP											# don't kill jobs
setopt NO_CHECK_JOBS
setopt correct                                  		# spelling correction for commands
setopt autocd
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
zplugin load "denysdovhan/spaceship-prompt"
zplugin ice wait"0" blockf lucid
zplugin light "zsh-users/zsh-completions"
zplugin ice wait'0' atload'_zsh_autosuggest_start' lucid
zplugin light "zsh-users/zsh-autosuggestions"
zplugin snippet /home/jemag/lib/azure-cli/az.completion
zplugin snippet /home/jemag/.config/zsh/plugins/fzf/key-bindings.zsh
zplugin ice svn
zplugin snippet OMZ::plugins/vi-mode
# Syntax Highlighting (should always be at the end)
zplugin ice wait"0" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting


#########
# spaceship settings
#########
spaceship_vi_mode_enable()
SPACESHIP_VI_MODE_SHOW=true

#########
# vim mode settings
########
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
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

#########
# keybinds
#########
bindkey '^f' autosuggest-accept

# remove lines from history with this function
histrm() { LC_ALL=C sed --in-place '/$1/d' $HISTFILE }

# add to path
path+=/root/.gem/ruby/2.5.0/bin
path+=('/home/jemag/bin/')
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
# [ -f ~/.config/zsh/plugins/fzf/key-bindings.zsh ] && source ~/.config/zsh/plugins/fzf/key-bindings.zsh
FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_OPTS="
    --no-mouse --height 50% -1 --reverse --multi --inline-info
    --color=dark
    --color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
    --color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
    "
export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_ALT_C_COMMAND='fd --type d $FD_OPTIONS'
export JAVA_HOME=/usr/lib/jvm/default
export CHROME_BIN=/usr/bin/chromium
export EDITOR=nvim
export GRAILS_HOME=/home/jemag/bin/grails-2.4.4
export PATH
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export PATH=$PATH:/home/jemag/bin

