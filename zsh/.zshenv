typeset -U path
# export JAVA_HOME=/usr/lib/jvm/default
export EDITOR=nvim
export OBSIDIAN_VAULT="/home/jemag/H/obsidian"
export NXV_API_URL=https://nxv.urandom.io
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
export HELM_REGISTRY_CONFIG=~/.docker/config.json
export PATH

prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}
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
export PATH=$PATH:$GRAILS_HOME/bin
export PATH=$PATH:/home/jemag/.local/bin
export PATH=$PATH:/home/jemag/.yarn/bin
prepend_path "${KREW_ROOT:-$HOME/.krew}/bin"
export KUBECTL_EXTERNAL_DIFF="difft --color=always"
# Enables opencode's built-in `websearch` tool (Exa-backed, no API key required).
# Without this, websearch is only registered for the first-party `opencode` provider.
export OPENCODE_ENABLE_EXA=1
