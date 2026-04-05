#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
IN_DIR="$REPO_ROOT/dotfiles/gnome"

apply_if_exists() {
  local dconf_path="$1"
  local source_file="$2"

  if [ -f "$source_file" ]; then
    echo "Applying: ${source_file#$REPO_ROOT/}"
    dconf load "$dconf_path" < "$source_file"
  else
    echo "Skipping missing file: ${source_file#$REPO_ROOT/}"
  fi
}

apply_if_exists /org/gnome/desktop/ "$IN_DIR/desktop.dconf"
apply_if_exists /org/gnome/shell/ "$IN_DIR/shell.dconf"
apply_if_exists /org/gnome/mutter/ "$IN_DIR/mutter.dconf"

echo "GNOME settings applied."