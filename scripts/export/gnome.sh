#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="$REPO_ROOT/dotfiles/gnome"

mkdir -p "$OUT_DIR"

CHANGED=0

export_if_changed() {
  local dconf_path="$1"
  local target_file="$2"

  local tmp
  tmp="$(mktemp)"

  dconf dump "$dconf_path" > "$tmp"

  if [ ! -f "$target_file" ] || ! cmp -s "$tmp" "$target_file"; then
    mv "$tmp" "$target_file"
    echo "Updated: ${target_file#"$REPO_ROOT"/}"
    CHANGED=1
  else
    rm "$tmp"
    echo "No change: ${target_file#"$REPO_ROOT"/}"
  fi
}

export_if_changed /org/gnome/desktop/ "$OUT_DIR/desktop.dconf"
export_if_changed /org/gnome/shell/ "$OUT_DIR/shell.dconf"
export_if_changed /org/gnome/mutter/ "$OUT_DIR/mutter.dconf"

exit "$CHANGED"