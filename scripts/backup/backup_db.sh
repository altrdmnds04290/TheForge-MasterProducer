#!/bin/bash
echo "[Backup] (placeholder) backing up DB to backups/"
mkdir -p backups
touch backups/db_$(date +%F_%H-%M-%S).sql
