# Termux + Termux:Boot Setup (PhoenixForge)

This guide walks you through installing Termux, setting up Termux:Boot, installing runtime dependencies (Node/Python), and wiring a pm2 startup script so PhoenixForge daemons and dev servers start on boot.

1) Install Termux and Termux:Boot
- Install Termux (F-Droid recommended: https://f-droid.org) and Termux:Boot.

2) Prepare storage access
- Open Termux and run:
```bash
termux-setup-storage
```
- This gives Termux access to shared storage (useful if you keep the repo on internal storage or SD card).

3) Clone your repo onto the device (recommended location: shared storage so it persists)
```bash
# in Termux
cd $HOME/storage/shared
git clone https://github.com/alt3r3d-pho3nix/TheForge-MasterProducer.git
# or put the repo on internal home: $HOME/PhoenixForge-MasterProducer
```

4) Install packages in Termux
```bash
pkg update -y && pkg upgrade -y
pkg install nodejs python git -y
# Optional: install pip packages and pm2
python3 -m pip install --user uvicorn fastapi
npm install -g pm2
```

5) Install pm2 (recommended) and test processes
```bash
# ensure npm global bin is in PATH (Termux typically uses /data/data/com.termux/files/usr/bin)
pm install -g pm2
cd $HOME/storage/shared/PhoenixForge-MasterProducer
# try starting the pm2 process file
pm2 start scripts/termux/pm2-processes.json
pm2 save
pm2 list
```

6) Termux:Boot
- Copy the starter script into a Termux boot path. You can use the sample file in the repo:
```bash
cp scripts/termux/termux_pm2_start.sh ~/.termux/boot/start.sh
chmod +x ~/.termux/boot/start.sh
```
- On reboot, Termux:Boot will run the script and pm2 will restore/manage processes.

7) Optional: disable battery optimizations for Termux so Android doesn't kill background processes.

8) Notes
- pm2 persists process list across reboots when `pm2 save` is used.
- If your repo is on SD card, update the `REPO_DIR` in `~/.termux/boot/start.sh` to the correct path.
- For production usage (not dev), run the API via systemd on Ubuntu or via a VPS; Termux is recommended for mobile experimentation only.

