#!/bin/bash
set -e
echo "[Repair] PhoenixForge cleansing..."
# lightweight safe repair: reinstall JS deps only
if command -v pnpm >/dev/null 2>&1; then
  pnpm install || true
elif command -v npm >/dev/null 2>&1; then
  npm install || true
fi
echo "[Repair] Complete"
