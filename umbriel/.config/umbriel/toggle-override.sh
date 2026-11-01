#!/usr/bin/env sh
# Toggle a gitignored optional include that overrides a setting.
#   toggle-override.sh <name> <toml>
# Creates ~/.config/umbriel/<name>-override.toml with <toml>, or removes it if it
# exists. Umbriel reloads when an optional include appears/disappears; the
# explicit reload is just belt and braces.
# Used by Mod+G (gaps) and Mod+Shift+W (tab bar) in config.toml.
name="$1"
toml="$2"
override="${XDG_CONFIG_HOME:-$HOME/.config}/umbriel/${name}-override.toml"
if [ -e "$override" ]; then
  rm -f "$override"
else
  printf '%b\n' "$toml" > "$override"
fi
# umbriel msg config-reload
