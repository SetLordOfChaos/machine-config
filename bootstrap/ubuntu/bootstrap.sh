#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NIX_DIR="$REPO_ROOT/nix"
USERNAME="$(whoami)"

NIX_BIN="/nix/var/nix/profiles/default/bin/nix"
NIX_PROFILE_SH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

echo "==> Installing required Ubuntu packages"
sudo apt update
sudo apt install -y curl git xz-utils

# --- Install Nix if not already installed ---
if [ -x "$NIX_BIN" ]; then
  echo "==> Nix already installed"
else
  echo "==> Installing Nix (non-interactive)"
  sh <(curl -L https://nixos.org/nix/install) --daemon --yes
fi

# --- Load Nix into current shell ---
echo "==> Loading Nix into current shell"
if [ -e "$NIX_PROFILE_SH" ]; then
  # shellcheck disable=SC1090
  . "$NIX_PROFILE_SH"
else
  echo "ERROR: Nix profile script not found"
  exit 1
fi

# --- Verify nix is available ---
echo "==> Verifying Nix is available"
if ! command -v nix >/dev/null 2>&1; then
  echo "ERROR: nix not found in PATH"
  exit 1
fi

# --- Enable flakes ---
echo "==> Ensuring flakes are enabled"
sudo mkdir -p /etc/nix
if [ ! -f /etc/nix/nix.conf ]; then
  echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf >/dev/null
elif ! grep -q "experimental-features = nix-command flakes" /etc/nix/nix.conf; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null
fi

# --- Restart nix-daemon ---
echo "==> Restarting nix-daemon"
sudo systemctl restart nix-daemon || true

# --- Clean Ubuntu default shell files (important!) ---
echo "==> Removing Ubuntu default shell files"
rm -f "$HOME/.bashrc" "$HOME/.profile"

# --- Apply Home Manager ---
echo "==> Applying Home Manager config"
cd "$NIX_DIR"
nix run github:nix-community/home-manager -- switch --flake ".#$USERNAME"

echo "==> Bootstrap complete"
echo "👉 Open a NEW terminal to load your environment"