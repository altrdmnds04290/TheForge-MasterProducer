#!/usr/bin/env bash
# PhoenixForge-OS-2225 Full Bootstrap (Steps 1–14)
# Usage: bash bootstrap.sh
set -euo pipefail

# Work in repository root
cd /workspaces/TheForge-MasterProducer || exit 1

# NOTE: This script creates the filesystem layout and placeholder files
# exactly as described in the codex plan. It is intentionally conservative
# (placeholders and safe defaults) so it can run on Ubuntu/UserLAnd/Termux
# without requiring secrets or heavy model checkpoints.

# === Clean workspace (non-destructive: only create directories/files) ===
mkdir -p apps/forge-web apps/forge-api apps/forge-mobile apps/forge-admin \
  packages/{ai,music,voice,vision,bots,soulmirror,shared,db,auth,payments,utils,ui} \
  infra/{docker,k8s,nginx,ssl,cdn,monitoring,logging,systemd} \
  scripts/{daemons,backup,hooks} tests docs web android ubuntu

# === Root package.json ===
cat > package.json <<'JSON'
{
  "name": "PhoenixForge-MasterProducer",
  "private": true,
  "type": "module",
  "workspaces": ["apps/*", "packages/*"],
  "scripts": {
    "dev:web": "pnpm --filter forge-web dev",
    "dev:api": "pnpm --filter forge-api dev",
    "dev:mobile": "pnpm --filter forge-mobile start",
    "dev:admin": "pnpm --filter forge-admin dev",
    "build": "pnpm -r build",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "format": "prettier --write .",
    "wizard": "node scripts/wizard.js status"
  },
  "devDependencies": {
    "eslint": "^9.0.0",
    "prettier": "^3.0.0",
    "concurrently": "^8.0.0",
    "typescript": "^5.0.0"
  }
}
JSON

# === Wizard core + repair/upgrade scripts ===
mkdir -p scripts
cat > scripts/wizard.js <<'JS'
#!/usr/bin/env node
import { execSync } from "child_process";
const cmd = process.argv[2] || "status";
switch (cmd) {
  case "heal":
    execSync("bash scripts/self_repair.sh", { stdio: "inherit" });
    break;
  case "upgrade":
    execSync("bash scripts/self_upgrade.sh", { stdio: "inherit" });
    break;
  case "status":
    console.log({ time: new Date().toISOString(), pulse: "alive" });
    break;
  case "mirror":
    console.log({ soulmirror: true, persona: "ALT3R3D-PHO3NIX" });
    break;
  default:
    console.log("Wizard usage: heal | upgrade | status | mirror");
}
JS
chmod +x scripts/wizard.js

cat > scripts/self_repair.sh <<'SH'
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
SH
chmod +x scripts/self_repair.sh

cat > scripts/self_upgrade.sh <<'SH'
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
SH
chmod +x scripts/self_upgrade.sh

# === Forge Web (skeleton) ===
mkdir -p apps/forge-web/src/pages apps/forge-web/src/components apps/forge-web/src/hooks apps/forge-web/src/styles
cat > apps/forge-web/package.json <<'JSON'
{
  "name": "forge-web",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^7.0.2",
    "axios": "latest",
    "tailwindcss": "latest"
  },
  "devDependencies": {
    "vite": "^5.4.0"
  }
}
JSON

cat > apps/forge-web/src/pages/Home.jsx <<'JSX'
import React from "react";
export default function Home(){
  return (
    <div className="p-8">
      <h1 className="text-4xl font-bold">PhoenixForge-OS-2225</h1>
      <p className="mt-4">SoulMirror active. Ember theme default.</p>
    </div>
  )
}
JSX

cat > apps/forge-web/src/pages/Feed.jsx <<'JSX'
import React, { useState } from "react";
import Comments from "../components/Comments";
import Reactions from "../components/Reactions";
import Upload from "../components/Upload";
export default function Feed(){
  const [posts, setPosts] = useState([
    { id: 1, user: "ALT3R3D-PHO3NIX", text: "Rising through smoke." },
    { id: 2, user: "Altered-Minds", text: "Wallet empty, lungs full 🌿" }
  ]);
  const [input, setInput] = useState("");
  return (
    <div className="p-8">
      <h2 className="text-2xl mb-4">Community Feed</h2>
      <form onSubmit={(e)=>{e.preventDefault(); setPosts([...posts,{id:Date.now(),user:"You",text:input}]); setInput("")}}>
        <input value={input} onChange={(e)=>setInput(e.target.value)} placeholder="Post something..." className="w-full p-2 bg-zinc-800 border border-zinc-700 rounded" />
      </form>
      <div className="mt-6 space-y-6">
        {posts.map(p=> (
          <div key={p.id} className="border p-3 bg-zinc-900 rounded">
            <p className="font-semibold">{p.user}</p>
            <p>{p.text}</p>
            <Reactions />
            <Comments postId={p.id} />
            <Upload />
          </div>
        ))}
      </div>
    </div>
  )
}
JSX

cat > apps/forge-web/src/components/Comments.jsx <<'JSX'
import React, { useState } from "react";
export default function Comments({postId}){
  const [comments, setComments] = useState([ {id:1,user:"ALT3R3D-PHO3NIX",text:"🔥 Eternal rise"} ]);
  const [input, setInput] = useState("");
  return (
    <div className="mt-4">
      <h3 className="font-semibold mb-2">Comments</h3>
      <form onSubmit={(e)=>{e.preventDefault(); setComments([...comments,{id:Date.now(),user:"You",text:input}]); setInput("")}}>
        <input value={input} onChange={(e)=>setInput(e.target.value)} placeholder="Leave a comment..." className="w-full bg-zinc-700 text-white p-2 rounded" />
      </form>
      <div className="mt-3 space-y-2">
        {comments.map(c=> (
          <div key={c.id} className="p-2 bg-zinc-800 rounded"><p className="font-bold">{c.user}</p><p>{c.text}</p></div>
        ))}
      </div>
    </div>
  )
}
JSX

cat > apps/forge-web/src/components/Reactions.jsx <<'JSX'
import React, { useState } from "react";
export default function Reactions(){
  const [likes, setLikes] = useState(0);
  const [flares, setFlares] = useState(0);
  return (
    <div className="flex gap-3 mt-2">
      <button className="px-2 py-1 bg-amber-600 rounded" onClick={()=>setLikes(likes+1)}>👍 {likes}</button>
      <button className="px-2 py-1 bg-red-600 rounded" onClick={()=>setFlares(flares+1)}>🔥 {flares}</button>
    </div>
  )
}
JSX

cat > apps/forge-web/src/components/Upload.jsx <<'JSX'
import React, { useState } from "react";
export default function Upload(){
  const [file, setFile] = useState(null);
  return (
    <div className="mt-4">
      <h3 className="font-semibold mb-2">Upload Media</h3>
      <input type="file" onChange={(e)=>setFile(e.target.files[0])} className="mb-2" />
      {file && <p className="text-sm text-zinc-400">Selected: {file.name}</p>}
      <button className="bg-amber-600 px-3 py-1 rounded text-white">Upload</button>
    </div>
  )
}
JSX

# === Forge API (FastAPI) skeleton ===
mkdir -p apps/forge-api/src/routes
cat > apps/forge-api/main.py <<'PY'
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="PhoenixForge-OS-2225 API")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

@app.get("/")
def root():
    return {"PhoenixForge": "OS-2225", "status": "alive"}
PY

cat > apps/forge-api/src/routes/feed.py <<'PY'
from fastapi import APIRouter
router = APIRouter()

posts = [
    {"id": 1, "user": "ALT3R3D-PHO3NIX", "text": "Rising through smoke."},
    {"id": 2, "user": "Altered-Minds", "text": "Wallet empty, lungs full 🌿"}
]

@router.get("/")
def get_feed():
    return posts

@router.post("/")
def add_post(user: str, text: str):
    post = {"id": len(posts)+1, "user": user, "text": text}
    posts.append(post)
    return post
PY

# Wire up routes in a minimal way for local development
cat >> apps/forge-api/main.py <<'PY'
from apps.forge_api.src.routes import feed as feed_route  # type: ignore
app.include_router(feed_route.router, prefix="/feed", tags=["Feed"])  # type: ignore
PY

# === Mobile (Expo) skeleton ===
mkdir -p apps/forge-mobile
cat > apps/forge-mobile/package.json <<'JSON'
{
  "name": "forge-mobile",
  "private": true,
  "main": "node_modules/expo/AppEntry.js",
  "scripts": {
    "start": "expo start"
  },
  "dependencies": {
    "expo": "^51.0.0",
    "react": "18.3.1",
    "react-native": "0.74.0"
  }
}
JSON

cat > apps/forge-mobile/App.js <<'JS'
import React, { useState } from "react";
import { Text, View, TextInput, Button, FlatList, StyleSheet } from "react-native";
export default function App(){
  const [posts, setPosts] = useState([{id:'1', user:'ALT3R3D-PHO3NIX', text:'Rising through smoke.'}]);
  const [input, setInput] = useState("");
  return (
    <View style={styles.container}>
      <Text style={styles.title}>PhoenixForge Mobile</Text>
      <TextInput style={styles.input} placeholder="Post something..." placeholderTextColor="#999" value={input} onChangeText={setInput} />
      <Button title="Post" onPress={()=>{ setPosts([...posts,{id:Date.now().toString(),user:'You',text:input}]); setInput(""); }} />
      <FlatList data={posts} renderItem={({item})=> (
        <View style={styles.post}><Text style={styles.user}>{item.user}</Text><Text style={styles.text}>{item.text}</Text></View>
      )} />
    </View>
  )
}
const styles = StyleSheet.create({ container: { flex:1, backgroundColor:'#000', padding:20 }, title: { fontSize:24, color:'#fff', marginBottom:10 }, input:{ backgroundColor:'#222', color:'#fff', marginBottom:10, padding:8 }, post:{ padding:10, backgroundColor:'#111', marginVertical:5 }, user:{ fontWeight:'bold', color:'#facc15'}, text:{ color:'#fff'} })
JS

# === Admin (skeleton) ===
mkdir -p apps/forge-admin/src/pages
cat > apps/forge-admin/package.json <<'JSON'
{
  "name": "forge-admin",
  "private": true,
  "scripts": { "dev": "vite" },
  "dependencies": { "react":"^18.3.1","react-dom":"^18.3.1","react-router-dom":"^7.0.2","tailwindcss":"latest" },
  "devDependencies": { "vite": "^5.4.0" }
}
JSON

cat > apps/forge-admin/src/pages/Dashboard.jsx <<'JSX'
import React from "react";
export default function Dashboard(){
  return <div className="p-8"><h1 className="text-3xl font-bold">Forge Admin</h1><p>System status: Online.</p></div>
}
JSX

# === Packages skeleton (placeholders) ===
for p in ai music voice vision bots soulmirror shared db auth payments utils ui; do
  mkdir -p packages/$p/src
  cat > packages/$p/src/index.ts <<'TS'
export function placeholder() { return { name: "$p", status: "ok" } }
TS
done

# === Infra: docker-compose + nginx placeholders ===
mkdir -p infra/docker infra/nginx infra/k8s
cat > infra/docker/docker-compose.yml <<'YAML'
version: "3.8"
services:
  api:
    image: python:3.11
    command: sh -c "python3 apps/forge-api/main.py || uvicorn apps.forge_api.main:app --host 0.0.0.0 --port 8000"
    ports: ["8000:8000"]
  web:
    image: node:20
    command: sh -c "cd apps/forge-web && npm run dev"
    ports: ["3000:3000"]
YAML

cat > infra/nginx/default.conf <<'CONF'
server {
  listen 80;
  server_name phoenixforge.local;
  location / { proxy_pass http://web:3000; }
  location /api { proxy_pass http://api:8000; }
}
CONF

# === Monitoring / logging (placeholders) ===
mkdir -p infra/monitoring infra/logging
cat > infra/monitoring/prometheus.yml <<'YAML'
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'phoenixforge'
    static_configs:
      - targets: ['api:8000','web:3000']
YAML

# === Daemons & backups (lightweight placeholders) ===
mkdir -p scripts/daemons scripts/backup
cat > scripts/daemons/self_repair.js <<'JS'
#!/usr/bin/env node
setInterval(()=>console.log('[Daemon] repair heartbeat'), 1000*60*15);
JS
chmod +x scripts/daemons/self_repair.js

cat > scripts/daemons/self_backup.js <<'JS'
#!/usr/bin/env node
setInterval(()=>console.log('[Daemon] backup heartbeat'), 1000*60*60*6);
JS
chmod +x scripts/daemons/self_backup.js

cat > scripts/backup/backup_db.sh <<'SH'
#!/bin/bash
echo "[Backup] (placeholder) backing up DB to backups/"
mkdir -p backups
touch backups/db_$(date +%F_%H-%M-%S).sql
SH
chmod +x scripts/backup/backup_db.sh

# === SoulMirror core pieces (lightweight) ===
mkdir -p packages/soulmirror/src/fingerprint
cat > packages/soulmirror/src/fingerprint/index.ts <<'TS'
import crypto from 'crypto';
export function generateFingerprint(headers: Record<string,string>, ua: string, ip: string) {
  const base = `${ua}-${ip}-${headers['accept-language']||''}`;
  return crypto.createHash('sha256').update(base).digest('hex');
}
TS

cat > packages/soulmirror/src/theme.ts <<'TS'
export function resolveTheme(persona:string, vibe:string){
  if(persona==='ALT3R3D-PHO3NIX') return vibe==='creator'?'ember-dark':'ember';
  if(persona==='Altered-Minds') return vibe==='consumer'?'neon-green':'psychedelic';
  return 'default';
}
TS

# === Tests placeholders ===
mkdir -p tests/api tests/e2e/web tests/community tests/soulmirror
cat > tests/api/test_feed.py <<'PY'
from fastapi.testclient import TestClient
from apps.forge_api.main import app
client = TestClient(app)

def test_root():
    r = client.get('/')
    assert r.status_code == 200
PY

cat > tests/soulmirror/test_fingerprint.ts <<'TS'
import { generateFingerprint } from '../../packages/soulmirror/src/fingerprint/index';
console.log('fp', generateFingerprint({'accept-language':'en-US'}, 'UA', '127.0.0.1'));
TS

# === CI / Docs placeholders ===
mkdir -p .github/workflows docs
cat > .github/workflows/test.yml <<'YAML'
name: PhoenixForge Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with: { node-version: 20 }
      - run: npm install -g pnpm || true
      - run: pnpm install || true
      - run: echo "CI placeholder: add tests"
YAML

cat > docs/README.md <<'MD'
# PhoenixForge-OS-2225
This repo contains the PhoenixForge monorepo skeleton (web, api, mobile, infra, packages, scripts).

Wizard commands: heal, repair, upgrade, mirror, status, deploy
MD

# === Final notes printed to user when script finishes ===
echo "\nBootstrap scaffolding complete. Files created under /workspaces/TheForge-MasterProducer."
echo "Next steps (recommended):"
echo "  1) Inspect files, edit secrets (STRIPE keys, DATABASE_URL) in .env before running services."
echo "  2) To install node deps: pnpm install (or npm install)."
echo "  3) Run API for testing: uvicorn apps.forge_api.main:app --reload --port 8000"
echo "  4) Run Web dev: cd apps/forge-web && pnpm dev (or npm run dev)"
echo "  5) Optionally run: node scripts/wizard.js status"

echo "Bootstrap finished."
