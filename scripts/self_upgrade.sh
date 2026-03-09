#!/bin/bash
set -e
echo "[Upgrade] PhoenixForge rebirth..."
git pull origin main || true
if command -v pnpm >/dev/null 2>&1; then
  pnpm install || true
elif command -v npm >/dev/null 2>&1; then
  npm install || true
fi
echo "[Upgrade] Complete"
