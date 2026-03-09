#!/data/data/com.termux/files/usr/bin/sh
# Termux:Boot startup script for PhoenixForge (place in ~/.termux/boot/start.sh)
# This is a safe, non-root startup script to launch the PhoenixForge daemons and dev servers
# on Android/Termux environments. It assumes you installed Termux, Termux:Boot, Node and Python.

# Adjust paths below if you store repo on SD card or different location.
REPO_DIR="$HOME/storage/shared/PhoenixForge-MasterProducer"
if [ ! -d "$REPO_DIR" ]; then
  REPO_DIR="$HOME/PhoenixForge-MasterProducer"
fi

cd "$REPO_DIR" || exit 0
# Start API (uvicorn) if python available
if command -v uvicorn >/dev/null 2>&1; then
  echo "Starting Forge API..."
  nohup uvicorn apps.forge_api.main:app --host 0.0.0.0 --port 8000 >/dev/null 2>&1 &
fi
# Start Web dev server if node available
if command -v pnpm >/dev/null 2>&1 || command -v npm >/dev/null 2>&1; then
  echo "Starting Forge Web (dev)..."
  (cd apps/forge-web && (pnpm dev 2>&1 >/dev/null &) || (npm run dev 2>&1 >/dev/null &))
fi
# Start repair daemon (node)
if command -v node >/dev/null 2>&1; then
  echo "Starting repair daemon..."
  nohup node scripts/daemons/self_repair.js >/dev/null 2>&1 &
fi
# Start backup daemon
if command -v node >/dev/null 2>&1; then
  echo "Starting backup daemon..."
  nohup node scripts/daemons/self_backup.js >/dev/null 2>&1 &
fi

echo "Termux:Boot PhoenixForge start script executed."
