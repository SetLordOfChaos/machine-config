#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
cd "$REPO_ROOT"

echo "==> Applying captured system state"
echo

./scripts/apply/gnome.sh

echo
echo "==> Apply complete"