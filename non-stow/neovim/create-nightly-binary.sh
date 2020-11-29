#!/bin/bash
ROOT_DIR="$HOME/Projects/github-reference/neovim"
BUILD_DIR="$ROOT_DIR/build"
SOURCE_DIR="$ROOT_DIR/src"

# Extract the source and if there were no errors, remove the previous build.
cd $SOURCE_DIR
git pull &&
	make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$BUILD_DIR &&
	rm -rf $BUILD_DIR &&
	make install &&
	git reset --hard; git clean -fxd &&
	cd -
ln -s "$BUILD_DIR/bin/nvim" ~/bin/nvim
