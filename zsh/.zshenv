typeset -U path
[ -f ~/.config/zsh/plugins/fzf/key-bindings.zsh ] && source ~/.config/zsh/plugins/fzf/key-bindings.zsh
export FZF_DEFAULT_OPTS="
--extended --bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down
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
export NODE_PATH="$(npm config get prefix)/lib/node_modules"
export NODE_BIN="$(npm config get prefix)/bin"
export EDITOR=nvim
export GIT_EDITOR=nvim
export VISUAL=nvim
export DIFFPROG="nvim -d"
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export TERMINAL=/usr/local/bin/st
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export CHROME_BIN=/usr/bin/chromium
export GRAILS_HOME=/home/jemag/bin/grails-2.4.4
export HELM_EXPERIMENTAL_OCI=1
export PATH
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export SONAR_SCANNER_HOME="/opt/sonar-scanner"
export PATH="${PATH}:${SONAR_SCANNER_HOME}/bin"
export PATH=$PATH:/home/jemag/.gem/ruby/2.7.0/bin
export PATH=$PATH:/home/jemag/bin
export PATH=$PATH:/snap/bin
export PATH=$PATH:/var/lib/snapd/snap/bin
export PATH=$PATH:/home/jemag/.cargo/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:$NODE_BIN
export PATH=$PATH:$GRAILS_HOME/bin
export PATH=$PATH:/home/jemag/.local/bin
export PATH=$PATH:/home/jemag/.yarn/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"