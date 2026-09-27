$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'modules')
]

mkdir ~/.cache/nu/zoxide
zoxide init nushell --cmd cd | save -f ~/.cache/nu/zoxide/zoxide.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/carapace.nu
