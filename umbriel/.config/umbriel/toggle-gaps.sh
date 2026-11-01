#!/usr/bin/env sh
# Mod+G: toggle layout gaps. Creating/removing an optional include makes
# Umbriel reload on its own; the explicit reload is just belt and braces.
override="${XDG_CONFIG_HOME:-$HOME/.config}/umbriel/gaps-override.toml"
if [ -e "$override" ]; then
  rm -f "$override"
else
  printf '[layout]\ngap = 0\n' > "$override"
fi
umbriel msg config-reload
