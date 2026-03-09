#!/data/data/com.termux/files/usr/bin/sh
# Simple log rotation helper for Termux logs used by PhoenixForge
REPO_DIR="$HOME/storage/shared/PhoenixForge-MasterProducer"
if [ ! -d "$REPO_DIR" ]; then
  REPO_DIR="$HOME/PhoenixForge-MasterProducer"
fi
LOG_DIR="$REPO_DIR/logs/termux"
mkdir -p "$LOG_DIR"

# keep 7 most recent logs
ls -1t "$LOG_DIR"/*.log 2>/dev/null | sed -n '8,$p' | xargs -r rm -f || true

echo "rotate done"
