#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Try to ensure Nix is available
if ! command -v nix >/dev/null 2>&1; then
  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    echo "Loading Nix environment..."
    # shellcheck source=/dev/null
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "❌ Nix is not installed or not available in PATH."
  echo "Run ./bootstrap/dev/setup-dev.sh first."
  exit 1
fi

echo "Entering dev shell..."
cd "$REPO_ROOT/nix"
exec nix develop