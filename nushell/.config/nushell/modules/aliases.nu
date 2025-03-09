export alias tf = terraform
export alias tg = terragrunt
export alias g = git
export alias n = nvim
export alias kn = n +'lua require(\"kubectl\").toggle()'
export alias ig = kubectl gadget
export alias gd = gh-dash
export alias y = yazi
export alias hm = home-manager
export alias ns = nix-search -r
export alias ":q" = exit
export alias ":qa" = exit
export alias digs = dig +short
export alias dign = dig +noall +answer
export alias digy = dig +yaml
export alias zl = zellij
export alias zla = zellij attach
export alias sue = sudoedit
export alias sup = sudo --preserve-env=PATH
export alias grep = grep --color
export alias tp = tmuxinator-fzf-start.sh
export alias ll = ls -l
export def lld [] {
  ls -l | sort-by modified
}
export def lad [] {
  ls -la | sort-by modified
}
export alias lt = eza -T
export alias l = ls -l
export alias la = ls -la
export alias ta = tmux attach -t
export def tlf [] {
  tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr }
export alias tf = terraform
export alias mirrorback = sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
export alias mirror = sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
export alias vifm = vifmrun
export alias tmuxa = tmux attach -t
export alias .. = cd ..
export alias cat = bat
export alias ac = argocd
export def d [] { dirs -v | fzf}
export alias dk = dirs -c
export alias tg = terragrunt
export alias ku = kustomize
export alias vd = viddy
export alias xo = xdg-open
export alias psa = ^ps auxf
export def faur [] {
  paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print $2}\")' | xargs -ro paru -S
}
export def psgrep [] {
  ^ps aux | grep -v grep | grep -i -e VSZ -e
}
export def psmem [] { ^ps auxf | ^sort -nr -k 4 }
export def pscpu [] { ^ps auxf | ^sort -nr -k 3 }
export alias pacu = sudo pacman -Syu                  # update only standard pkgs
export alias yaya = yay -Syu --aur --sudoloop              # update only AUR pkgs (yay)
export alias parua = paru -Syua --sudoloop             # update only AUR pkgs (paru)
export def ap [] {
  apropos -s 1 . | fzf --preview="man {1}" --preview-window=up | awk '{print $1}' | xargs man
  }
