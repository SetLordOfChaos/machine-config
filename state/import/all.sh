#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
cd "$REPO_ROOT"

echo "==> Importing captured system state"
echo

./state/import/gnome.sh

echo
echo "==> Import complete"