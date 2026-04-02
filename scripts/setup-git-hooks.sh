#!/bin/sh
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

HOOKS_DIR="$REPO_ROOT/.githooks"
mkdir -p "$HOOKS_DIR"

# Ensure hook is executable for current user.
chmod +x "$HOOKS_DIR/pre-push" 2>/dev/null || true

# Point git to the repo-bundled hooks (per-user setting).
git config core.hooksPath "$HOOKS_DIR"

echo "Git hooks installed."
echo "core.hooksPath set to: $HOOKS_DIR"

