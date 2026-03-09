#!/usr/bin/env bash
# APK build helper (instructions); does not perform signing.
# This script assumes you use Expo (managed workflow) and have an Expo account.
# It is a helper to build a debug APK for sideloading.
set -euo pipefail

# Ensure you have expo CLI installed globally:
# npm install -g expo-cli or use npx expo

# Steps to build an unsigned debug APK locally (recommended using EAS / expo):
cat <<'TXT'
1) Install expo CLI (if not already):
   npm install -g expo-cli

2) From repo root:
   cd apps/forge-mobile
   npm install

3) Start an expo build (classic):
   expo build:android -t apk
   # or use EAS (recommended) which requires an Expo account and EAS CLI
   # npm install -g eas-cli
   # eas build -p android --profile preview

4) When build completes, download the APK and sideload to device via adb:
   adb install -r <path-to-apk>

Note: For automation and CI, use EAS and build with a secure keystore for signing.
TXT
