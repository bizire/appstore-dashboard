#!/bin/bash
# App Store chart monitor — run via cron every 15 minutes
# Collects chart changes from Apple App Store and pushes to GitHub
set -euo pipefail

TRADE_DIR=~/PolyMarketTrade
DASHBOARD_DIR=~/appstore-dashboard

source ~/.bashrc
export DASHBOARD_REPO_APPSTORE="$DASHBOARD_DIR"

# Collect data
cd "$TRADE_DIR"
.venv/bin/python track_appstore.py

# Commit & push
cd "$DASHBOARD_DIR"
git add data/state.json data/events.json
git diff --cached --quiet && exit 0
git commit -m "data: $(date -u '+%Y-%m-%d %H:%M') UTC"
git push origin main
