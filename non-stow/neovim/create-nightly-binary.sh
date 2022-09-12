#!/bin/bash
set -euo pipefail
cd /tmp || exit
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
