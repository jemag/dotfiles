#!/bin/bash

set -euo pipefail

filename="$(echo "$1" | sed 's|C:/Users/brassarddesjardinsa/|/mnt/c/Users/brassarddesjardinsa/|g')"
/home/jemag/.local/share/bob/nvim-bin/nvim "$filename"
