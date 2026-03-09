# TheForge-MasterProducer — PhoenixForge-OS-2225

This repository is the PhoenixForge monorepo: web UI, API, mobile launcher, packages, infra, scripts and daemons. It is scaffolded for development on Ubuntu/UserLAnd and experimental deployment on Android via Termux/Termux:Boot.

Quick start (developer)

1) Clone & prepare

```bash
git clone https://github.com/alt3r3d-pho3nix/TheForge-MasterProducer.git
cd TheForge-MasterProducer
```

2) Ubuntu / UserLAnd setup (recommended for backend)

```bash
# run the helper (creates venv and installs Python deps)
bash scripts/setup_ubuntu.sh
# activate venv
. .venv/bin/activate
# start API
uvicorn apps.forge_api.main:app --reload --port 8000
# in another shell, start web dev
cd apps/forge-web
pnpm install    # or npm install
pnpm dev        # or npm run dev
```

3) Termux (Android) — Hybrid workflow (no root)

- Install Termux + Termux:Boot from F-Droid.
- In Termux:

```bash
termux-setup-storage
pkg update -y && pkg upgrade -y
pkg install nodejs git python -y
npm install -g pm2
# Clone repo to shared storage (so it persists)
cd $HOME/storage/shared
git clone https://github.com/alt3r3d-pho3nix/TheForge-MasterProducer.git
# Copy startup script
cp TheForge-MasterProducer/scripts/termux/termux_pm2_start.sh ~/.termux/boot/start.sh
chmod +x ~/.termux/boot/start.sh
```

- Reboot the phone; Termux:Boot will execute the script and pm2 should restore processes.

4) APK build (Expo)

See `scripts/build_apk.sh` for instructions. For CI builds and signing, use EAS (Expo Application Services) and store keystore/secrets in GitHub Secrets.

5) Running tests

Project has a small pytest smoke test for the API.

```bash
# from repo root (venv active)
python -m pytest tests/api/test_feed.py -q
```

Notes & safety

- Secrets: Replace placeholder keys in files and move secrets to a `.env` (use dotenv or GitHub Secrets for CI). Do not commit secrets.
- Heavy AI models are not bundled; offload to capable hosts.
- Termux is recommended for experimentation; production services should run on a server with systemd or container orchestration.

If you're busy, I prepared automation: a bootstrap script, Ubuntu setup helper, Termux startup scripts, pm2 process file, and systemd templates under `infra/systemd`.

Want me to: (pick one)
- Harden Termux startup with log rotation and monitoring (I can implement now)
- Add EAS CI workflow for signed APK builds (requires Expo/GitHub secrets)
- Add more API tests and a basic Playwright smoke test for web

