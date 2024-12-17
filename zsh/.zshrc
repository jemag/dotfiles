# zmodload zsh/zprof
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
# ci"
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


###########
# aliases
###########
alias ls="eza -g --time-style long-iso --icons=always"
alias kn="n +'lua require(\"kubectl\").toggle()'"
alias y="yazi"
alias hm="home-manager"
alias ns="nix-search -r"
alias :q="exit"
alias :qa="exit"
alias digs="dig +short"
alias dign="dig +noall +answer"
alias digy="dig +yaml"
alias zl="zellij"
alias zla="zellij attach"
alias sue="sudoedit"
alias grep="grep --color"
alias tp="tmuxinator-fzf-start.sh"
alias ll="ls -l"
alias lld="ls -l --sort=date"
alias lad="ls -la --sort=date"
alias lt="ls -T"
alias lt="ls -T"
alias l="ls -l"
alias la="ls -la"
alias lh="ls -lh"
alias lb="br -dsp"
alias ta="tmux attach -t"
alias tlf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias n="nvim"
alias jd="joplin --profile ~/.config/joplin-desktop"
alias tf="terraform"
alias mirrorback="sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup"
alias mirror="sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
alias vifm="vifmrun"
alias g="git"
alias tmuxa="tmux attach -t"
alias ..="cd .."
alias cat="bat"
alias ac="argocd"
alias d="dirs -v | fzf"
alias dk="dirs -c"
alias tg="terragrunt"
alias cd="z"
alias ku="kustomize"
alias vd="viddy "
alias xo="xdg-open "
alias psa="ps auxf"
alias faur="paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print $2}\")' | xargs -ro paru -S"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem="ps auxf | sort -nr -k 4"
alias pscpu="ps auxf | sort -nr -k 3"
alias pacu="sudo pacman -Syu"                  # update only standard pkgs
alias yaya="yay -Syu --aur --sudoloop"              # update only AUR pkgs (yay)
alias parua="paru -Syua --sudoloop"             # update only AUR pkgs (paru)
alias ap='apropos -s 1 . | fzf --preview='\''man {1}'\'' --preview-window=up | awk '\''{print $1}'\'' | xargs man'
tmuxpopup() {
  LBUFFER+=${$(fd --type f --follow --hidden --exclude .git --exclude node_modules | fzf-tmux-popup --preview 'bat --style=numbers --color=always --line-range :500 {}')}
}
zle -N tmuxpopup
bindkey '^[t' tmuxpopup
##########
# generic options
##########
KEYTIMEOUT=10
HISTFILE=~/.zsh/zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1				# all search results returned will be unique
HISTDUP=erase
setopt INC_APPEND_HISTORY					            # add commmand to history as soon as it's entered
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY									# save command timestamp
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS                        		# don't write duplicate entries in the history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE                        		# prefix commands you don't want stored with a space
setopt NO_HUP											# don't kill jobs
setopt NO_CHECK_JOBS
setopt autocd
setopt IGNOREEOF
setopt AUTO_PUSHD
setopt PUSHD_TO_HOME
setopt PUSHD_SILENT
setopt PUSHD_IGNORE_DUPS
# setopt PUSHD_MINUS
setopt CDABLE_VARS
unset zle_bracketed_paste
unsetopt rm_star_silent					            # ask for confirmation for `rm *' or `rm path/*'
unsetopt BEEP
# Include hidden files in autocomplete:
_comp_options+=(globdots)

##########
# zinit
##########
zinit light "hlissner/zsh-autopair"
# zinit load "denysdovhan/spaceship-prompt"
zinit light "zsh-users/zsh-completions"
# zinit load "jeffreytse/zsh-vi-mode"
# zinit load "softmoth/zsh-vim-mode"
zinit light Aloxaf/fzf-tab
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh
zinit light "zsh-users/zsh-autosuggestions"
# Syntax Highlighting (should always be at the end)
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light johanhaleby/kubetail

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zinit cdreplay -q
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
bindkey -r '^l'
# Use vim keys in tab complete menu:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
zmodload zsh/complist

# This will be our new default `ctrl+w` command
my-backward-delete-word() {
    # Copy the global WORDCHARS variable to a local variable. That way any
    # modifications are scoped to this function only
    local WORDCHARS=$WORDCHARS
    # Use bash string manipulation to remove `:` so our delete will stop at it
    WORDCHARS="${WORDCHARS//:}"
    # Use bash string manipulation to remove `/` so our delete will stop at it
    WORDCHARS="${WORDCHARS//\/}"
    # Use bash string manipulation to remove `.` so our delete will stop at it
    WORDCHARS="${WORDCHARS//.}"
    # zle <widget-name> will run an existing widget.
    zle backward-delete-word
}
# `zle -N` will create a new widget that we can use on the command line
zle -N my-backward-delete-word
# bind this new widget to `ctrl+w`
bindkey '^W' my-backward-delete-word

# This will be our `ctrl+alt+w` command
my-backward-delete-whole-word() {
    # Copy the global WORDCHARS variable to a local variable. That way any
    # modifications are scoped to this function only
    local WORDCHARS=$WORDCHARS
    # Use bash string manipulation to add `:` to WORDCHARS if it's not present
    # already.
    [[ ! $WORDCHARS == *":"* ]] && WORDCHARS="$WORDCHARS"":"
    # zle <widget-name> will run that widget.
    zle backward-delete-word
}
# `zle -N` will create a new widget that we can use on the command line
zle -N my-backward-delete-whole-word
# bind this new widget to `ctrl+alt+w`
bindkey '^[^w' my-backward-delete-whole-word

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -v '^?' backward-delete-char

#########
# keybinds
#########
bindkey '^f' autosuggest-accept
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# remove lines from history with this function
histrm() { LC_ALL=C sed --in-place '/$1/d' $HISTFILE }
# Source kubectl aliases
[ -f ~/.config/zsh/kubectl_aliases.zsh ] && source ~/.config/zsh/kubectl_aliases.zsh
# Source fzf
# Requires installation of fzf
# fzf wiki https://github.com/junegunn/fzf/wiki/examples
#
# Also for this setup, installation of fd and ripgrep
# More on fd https://github.com/sharkdp/fd
# More on ripgrep https://github.com/BurntSushi/ripgrep
# More on these tools https://bluz71.github.io/2018/06/07/ripgrep-fd-command-line-search-tools.html
#
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="
--extended --bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down
"
FD_OPTIONS="--follow --hidden --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --type f $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_CTRL_T_OPTS="
    --height 50% -1 --layout=reverse --multi --inline-info
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    "
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# fzf-dir() {
#   LBUFFER+=${$(fd --type directory --follow --hidden --exclude .git --exclude node_modules | fzf --height ${FZF_TMUX_HEIGHT:-40%})}
#   zle reset-prompt
# }
# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
export RPS1="$(vi_mode_prompt_info)"
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/home/jemag/.local/share/bob/nvim-bin:$PATH"
export PATH="/home/jemag/.nix-profile/bin:$PATH"
export NODE_PATH="$(npm config get prefix)/lib/node_modules"
export NODE_BIN="$(npm config get prefix)/bin"
source <(kubectl completion zsh)
source <(kustomize completion zsh)
[ -f ~/.zshsecretenv ] && source ~/.zshsecretenv
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
eval $(thefuck --alias fk)
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
stty -ixon
# zprof
