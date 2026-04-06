#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

git config core.hooksPath .githooks

echo "Git hooks enabled for this repo."
echo "Using hooks path: $(git config core.hooksPath)"