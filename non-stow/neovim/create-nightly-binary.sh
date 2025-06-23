#!/usr/bin/env bash
set -euo pipefail
[ -d "/tmp/neovim" ] && rm -rf /tmp/neovim
cd /tmp || exit
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
make install
