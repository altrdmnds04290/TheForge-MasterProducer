#!/usr/bin/env bash
set -euo pipefail

echo "[setup] Installing OS packages (sudo may be required)."
if command -v sudo >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y python3-pip python3-venv nodejs npm git curl
else
  apt update || true
  apt install -y python3-pip python3-venv nodejs npm git curl || true
fi

# Create venv for repo
python3 -m venv .venv
. .venv/bin/activate
pip install --upgrade pip
pip install fastapi uvicorn pytest httpx

# Install pnpm (recommended) and node deps
if command -v npm >/dev/null 2>&1; then
  npm install -g pnpm || true
fi

# Install repo JS deps where present
if [ -d "apps/forge-web" ]; then
  (cd apps/forge-web && pnpm install || npm install) || true
fi
if [ -d "apps/forge-admin" ]; then
  (cd apps/forge-admin && pnpm install || npm install) || true
fi

echo "[setup] Dependencies installed. To start API: . .venv/bin/uvicorn apps.forge_api.main:app --reload --port 8000"
