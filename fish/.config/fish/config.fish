#!/usr/bin/fish

fish_vi_key_bindings
set -g theme_display_user yes
set -g fish_prompt_pwd_dir_length 0
set -gx PATH /home/jemag/bin /home/jemag/.gem/ruby/2.6.0/bin $PATH
set -gx PATH $PATH $HOME/.krew/bin
set -gx PATH $PATH $HOME/go/bin
set -gx PATH $PATH $HOME/.cargo/bin
set -gx PATH $PATH $HOME/.local/bin
set -Ux EDITOR nvim
set -Ux CHROME_BIN chromium-browser
set -Ux JAVA_HOME /usr/lib/jvm/default
alias k="kubectl"
alias tf="terraform"
alias jd="joplin --profile ~/.config/joplin-desktop"
alias vim="nvim"
