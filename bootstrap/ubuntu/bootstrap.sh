#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NIX_DIR="$REPO_ROOT/nix"
USERNAME="$(whoami)"

echo "==> Installing required Ubuntu packages"
sudo apt update
sudo apt install -y curl git xz-utils

if ! command -v nix >/dev/null 2>&1; then
  echo "==> Installing Nix"
  sh <(curl -L https://nixos.org/nix/install) --daemon
else
  echo "==> Nix already installed"
fi

echo "==> Ensuring flakes are enabled"
sudo mkdir -p /etc/nix
if ! grep -q "experimental-features = nix-command flakes" /etc/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null
fi

echo "==> Restarting nix-daemon"
sudo systemctl restart nix-daemon || true

# Load nix into current shell if available
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Applying Home Manager config"
cd "$NIX_DIR"
nix run github:nix-community/home-manager -- switch --flake ".#$USERNAME"

echo "==> Done"
echo "You may want to log out and back in if shell changes don't appear immediately."