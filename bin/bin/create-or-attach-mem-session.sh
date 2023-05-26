#!/bin/bash

if ! (tmux ls | grep -qi mem) ; then
  tmuxinator start mem --suppress-tmux-version-warning
else
  tmux switch-client -t mem
fi
