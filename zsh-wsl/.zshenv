typeset -U path
# export JAVA_HOME=/usr/lib/jvm/default
export EDITOR=nvim
export OBSIDIAN_VAULT="/home/jemag/obsidian"
export NXV_API_URL=https://nxv.urandom.io
export GIT_EDITOR=nvim
export VISUAL=nvim
export DIFFPROG="nvim -d"
export MANPAGER='nvim +Man!'
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
export MANWIDTH=999
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GRAILS_HOME=/home/jemag/bin/grails-2.4.4
export HELM_EXPERIMENTAL_OCI=1
export HELM_REGISTRY_CONFIG=~/.docker/config.json
export PATH
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
for _gembin in $HOME/.local/share/gem/ruby/*/bin(N); do path+=$_gembin; done
unset _gembin
export PATH=$PATH:/home/jemag/bin
export PATH=$PATH:/home/jemag/.cargo/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:$NODE_BIN
export PATH=$PATH:$GRAILS_HOME/bin
export PATH=$PATH:/home/jemag/.local/bin
export PATH=$PATH:/home/jemag/.yarn/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export BROWSER=wsl-open
export KUBECTL_EXTERNAL_DIFF="difft --color=always"
# Enables opencode's built-in `websearch` tool (Exa-backed, no API key required).
# Without this, websearch is only registered for the first-party `opencode` provider.
export OPENCODE_ENABLE_EXA=1
