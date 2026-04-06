#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

echo "==> Setting up development environment"

NIX_PROFILE_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

# ---------------------------------------
# Step 1: Detect existing Nix install
# ---------------------------------------
if [ -f "$NIX_PROFILE_SCRIPT" ]; then
  echo "==> Existing Nix installation detected"
else
  echo "==> Nix not found. Installing Nix..."

  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# ---------------------------------------
# Step 2: Load Nix into current shell
# ---------------------------------------
if [ -f "$NIX_PROFILE_SCRIPT" ]; then
  echo "==> Loading Nix into current shell..."
  # shellcheck source=/dev/null
  . "$NIX_PROFILE_SCRIPT"
fi

# ---------------------------------------
# Step 3: Verify Nix works
# ---------------------------------------
if ! command -v nix >/dev/null 2>&1; then
  echo "❌ Nix is installed but still not available in PATH."
  echo "Open a new terminal and rerun this script."
  exit 1
fi

echo "==> Nix version:"
nix --version

# ---------------------------------------
# Step 4: Ensure flakes + nix-command are enabled
# ---------------------------------------
echo "==> Ensuring flakes are enabled"

if ! grep -Eq '^\s*experimental-features\s*=.*\bnix-command\b.*\bflakes\b' /etc/nix/nix.conf 2>/dev/null; then
  echo "==> Updating /etc/nix/nix.conf"
  sudo mkdir -p /etc/nix
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null

  echo "==> Restarting nix-daemon"
  sudo systemctl restart nix-daemon.service
fi

# Reload after nix.conf changes
if [ -f "$NIX_PROFILE_SCRIPT" ]; then
  # shellcheck source=/dev/null
  . "$NIX_PROFILE_SCRIPT"
fi

# ---------------------------------------
# Step 5: Set up git hooks
# ---------------------------------------
echo "==> Setting up git hooks"
"$REPO_ROOT/bootstrap/dev/setup-git-hooks.sh"

# ---------------------------------------
# Step 6: Pre-fetch devShell
# ---------------------------------------
echo "==> Preparing dev shell (this may take a moment)"
cd "$REPO_ROOT/nix"
nix develop --command true

# ---------------------------------------
# Done
# ---------------------------------------
echo
echo "✅ Dev environment setup complete!"
echo "Launching dev shell..."
echo

exec "$REPO_ROOT/bootstrap/dev/dev-shell.sh"