#!/usr/bin/env bash

# NOTE: the path in neovim should be wezterm
# the arguments should be : "start -- wsl -u jemag --shell-type standard  -- /home/jemag/bin/open-nvim-from-windows-joplin.sh"
set -euo pipefail

filename="$(echo "$1" | sed 's|C:/Users/brassarddesjardinsa/|/mnt/c/Users/brassarddesjardinsa/|g')"
/home/jemag/.local/share/bob/nvim-bin/nvim "$filename"
