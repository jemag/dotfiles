{ pkgs }:

pkgs.writeShellScriptBin "terraform-ls-terragrunt-shim" ''
  # terraform-ls "terraform.path" shim: terragrunt keeps the initialized module
  # (.terraform/, backend.tf, provider.tf) under .terragrunt-cache, so fetch
  # provider schemas from the most recently initialized copy there.
  if [[ "$1 $2" == "providers schema" && -d .terragrunt-cache ]]; then
    cache=$(find .terragrunt-cache -mindepth 3 -maxdepth 3 -name .terraform -type d -printf '%T@ %h\n' 2>/dev/null \
      | sort -rn | head -1 | cut -d' ' -f2-)
    if [[ -n "$cache" ]]; then
      exec terraform -chdir="$cache" "$@"
    fi
  fi
  exec terraform "$@"
''
