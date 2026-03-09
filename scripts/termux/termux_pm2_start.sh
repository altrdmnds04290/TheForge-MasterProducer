#!/data/data/com.termux/files/usr/bin/sh
# Hardened Termux startup script using pm2 for process management
# Place (or copy) this into ~/.termux/boot/start.sh on your device.

REPO_DIR="$HOME/storage/shared/PhoenixForge-MasterProducer"
if [ ! -d "$REPO_DIR" ]; then
  REPO_DIR="$HOME/PhoenixForge-MasterProducer"
fi

LOG_DIR="$REPO_DIR/logs/termux"
mkdir -p "$LOG_DIR"

# Simple rotation: keep the 7 most recent logs
rotate_logs() {
  ls -1t "$LOG_DIR"/*.log 2>/dev/null | sed -n '8,$p' | xargs -r rm -f || true
}
rotate_logs

cd "$REPO_DIR" || exit 0

# Ensure node present
if ! command -v node >/dev/null 2>&1; then
  echo "node not found in PATH — install nodejs in Termux" | tee -a "$LOG_DIR/termux_start.log"
  exit 0
fi

# Store pm2 state inside repo to avoid global conflicts
export PM2_HOME="$REPO_DIR/.pm2"
mkdir -p "$PM2_HOME"

# Install pm2 if missing (best-effort)
if ! command -v pm2 >/dev/null 2>&1; then
  echo "pm2 not found, attempting npm install -g pm2" | tee -a "$LOG_DIR/termux_start.log"
  npm install -g pm2 >>"$LOG_DIR/termux_start.log" 2>&1 || echo "pm2 install failed" | tee -a "$LOG_DIR/termux_start.log"
fi

# Start or resurrect processes using pm2 when available
if command -v pm2 >/dev/null 2>&1; then
  if [ -f "scripts/termux/pm2-processes.json" ]; then
    pm2 startOrReload scripts/termux/pm2-processes.json --update-env >>"$LOG_DIR/termux_start.log" 2>&1 || true
    pm2 save >>"$LOG_DIR/termux_start.log" 2>&1 || true
  else
    pm2 start --name forge-api --interpreter python3 apps/forge-api/main.py >>"$LOG_DIR/termux_start.log" 2>&1 || true
    pm2 start --name forge-web --cwd apps/forge-web -- npm -- run dev >>"$LOG_DIR/termux_start.log" 2>&1 || true
    pm2 start --name repair-daemon scripts/daemons/self_repair.js >>"$LOG_DIR/termux_start.log" 2>&1 || true
    pm2 start --name backup-daemon scripts/daemons/self_backup.js >>"$LOG_DIR/termux_start.log" 2>&1 || true
    pm2 save >>"$LOG_DIR/termux_start.log" 2>&1 || true
  fi
else
  # Fallback to nohup with logs
  if command -v uvicorn >/dev/null 2>&1; then
    nohup uvicorn apps.forge_api.main:app --host 0.0.0.0 --port 8000 >>"$LOG_DIR/forge-api.log" 2>&1 &
  fi
  (cd apps/forge-web && nohup npm run dev >>"$LOG_DIR/forge-web.log" 2>&1 &) || true
  nohup node scripts/daemons/self_repair.js >>"$LOG_DIR/repair-daemon.log" 2>&1 &
  nohup node scripts/daemons/self_backup.js >>"$LOG_DIR/backup-daemon.log" 2>&1 &
fi

echo "Termux pm2 startup script executed." | tee -a "$LOG_DIR/termux_start.log"
