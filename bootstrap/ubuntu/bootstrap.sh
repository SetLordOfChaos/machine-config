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

if [ -x "$NIX_BIN" ]; then
  echo "==> Nix already installed on disk"
else
  echo "==> Installing Nix"
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

echo "==> Loading Nix into current shell"
if [ -e "$NIX_PROFILE_SH" ]; then
  # shellcheck disable=SC1090
  . "$NIX_PROFILE_SH"
else
  echo "ERROR: Nix profile script not found at $NIX_PROFILE_SH"
  exit 1
fi

echo "==> Verifying Nix is available"
if ! command -v nix >/dev/null 2>&1; then
  echo "ERROR: nix is still not available in PATH after loading profile"
  exit 1
fi

echo "==> Ensuring flakes are enabled"
sudo mkdir -p /etc/nix
if [ ! -f /etc/nix/nix.conf ]; then
  sudo touch /etc/nix/nix.conf
fi

if ! grep -q "^experimental-features = nix-command flakes$" /etc/nix/nix.conf; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null
fi

echo "==> Restarting nix-daemon"
sudo systemctl restart nix-daemon || true

echo "==> Applying Home Manager config"
cd "$NIX_DIR"
nix run github:nix-community/home-manager -- switch --flake ".#$USERNAME"

echo "==> Done"
echo "You may want to log out and back in if shell changes don't appear immediately."