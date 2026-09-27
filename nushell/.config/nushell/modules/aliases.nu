export alias g = git
export alias n = nvim
export alias ny = nvim "+set ft=yaml"
export alias nj = nvim "+set ft=json"
export alias kn = nvim "+lua require(\"kubectl\").toggle()"
export alias c = claude
export alias oc = opencode
export alias ol = ollama
export alias cg = chainctl
export alias ch = checkov
export alias dv = devbox
export alias cl = calicoctl
export alias ig = kubectl gadget
export alias wo = wsl-open
export alias gd = gh-dash
export alias y = yazi
export alias hm = home-manager
export alias ns = nix-search -r
export alias ":q" = exit
export alias ":qa" = exit
export alias digs = dig +short
export alias dign = dig +noall +answer
export alias digy = dig +yaml
export alias kcac = kubectl cost --service-port 9003 --service-name opencost --kubecost-namespace opencost --allocation-path /allocation/compute
export alias rk = rakkess
export alias zl = zellij
export alias zla = zellij attach
export alias sue = sudoedit
export alias sup = sudo --preserve-env=PATH
export alias grep = grep --color
export alias ll = ls -la
export def lld [] {
  ls -l | sort-by modified
}
export def lad [] {
  ls -la | sort-by modified
}
export alias lt = eza -T
export alias lta = eza -Ta
export alias l = ls
export alias la = ls -a
export alias ta = tmux attach -t
export alias tmuxa = tmux attach -t
export def tlf [] {
  tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
}
export alias jd = joplin --profile ~/.config/joplin-desktop
export alias tf = terraform
export alias tg = terragrunt
export alias vifm = vifmrun
export alias .. = cd ..
export alias cat = bat
export alias ac = argocd
export alias ku = kustomize
export alias vd = viddy
export alias xo = xdg-open
export alias psa = ^ps auxf
export def psgrep [pattern: string] {
  ^ps aux | ^grep -v grep | ^grep -i -e VSZ -e $pattern
}
export def psmem [] { ^ps auxf | ^sort -nr -k 4 }
export def pscpu [] { ^ps auxf | ^sort -nr -k 3 }
export def ap [] {
  apropos -s 1 . | fzf --preview="man {1}" --preview-window=up | awk '{print $1}' | xargs man
}

export def --wrapped tp [...args] {
  ^($env.HOME | path join ".config/herdr/scripts/tmuxinator-launch.nu") ...$args
}

export def --wrapped tk [...args] {
  if ($args.0? == "show") {
    ^tk show --dangerous-allow-redirect ...($args | skip 1)
  } else {
    ^tk ...$args
  }
}

export def tfs [] {
  ^terraform show -json aks-tfplan | from json | get resource_changes
  | where change.actions != [no-op]
  | each {|r| $"($r.change.actions | str join ","): ($r.address)" }
  | str join (char nl)
}

# argonaut reads the argocd token from ~/.config/argocd/config once at startup and never
# refreshes it, while Entra ID id_tokens only live 65 min. Refresh every context before
# launching, since argonaut can switch contexts from inside the TUI.
export def --wrapped argonaut [...args] {
  # `argocd context` rows are `[*] NAME SERVER`; NAME is always the second-to-last field
  let rows = ^argocd context | lines | skip 1 | each {|l| $l | split row -r '\s+' | where $it != "" }
  let names = $rows | each {|r| $r | reverse | get 1 }
  let cur = $rows | where {|r| $r.0 == "*" } | each {|r| $r | reverse | get 1 } | get 0?
  if ($names | is-empty) {
    error make {msg: "argonaut: no argocd contexts - run 'ac login <server> --sso --grpc-web'"}
  }
  let failed = $names | where {|ctx|
    let res = do { ^argocd account session-token --argocd-context $ctx } | complete
    if $res.exit_code != 0 { print -e $res.stderr }
    $res.exit_code != 0
  }
  for ctx in $failed { print -e $"argonaut: token refresh failed for context ($ctx)" }
  if $cur in $failed {
    error make {msg: $"argonaut: run 'ac login ($cur) --sso --grpc-web' to re-authenticate"}
  }
  ^argonaut ...$args
}

# remove lines from history with this function
export def histrm [pattern: string] {
  open $nu.history-path | query db "DELETE FROM history WHERE command_line LIKE ?" -p [$"%($pattern)%"]
}
