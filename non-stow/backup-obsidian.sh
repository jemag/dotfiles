#!/bin/bash
set -euo pipefail

obsidian_parent="/home/jemag/H"
obsidian_vault="obsidian"
backup_dir="/home/jemag/F/obsidian-backups"
backup_file="obsidian_$(date --iso-8601).tar.gz"

cd "$obsidian_parent"
tar -czf "$backup_dir/$backup_file" "$obsidian_vault"

# Remove old backups if there are more than 3
cd "$backup_dir" || exit
find . -mindepth 1 -type f -name "obsidian_*" | sort --reverse | awk 'NR>3' | xargs rm
