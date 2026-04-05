#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
cd "$REPO_ROOT"

echo "==> Exporting captured system state"

CHANGED=0

run_export() {
  local script="$1"

  echo
  echo "-- Running: ${script#./}"

  if "$script"; then
    echo "-- No changes from ${script#./}"
  else
    echo "-- Changes detected from ${script#./}"
    CHANGED=1
  fi
}

run_export ./scripts/export/gnome.sh

echo
if [ "$CHANGED" -eq 1 ]; then
  echo "==> Export complete: changes detected"
else
  echo "==> Export complete: no changes"
fi