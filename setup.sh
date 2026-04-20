#!/usr/bin/env bash
set -e

./check_env.sh

echo "[+] Creating Python virtual environment"
python3 -m venv .venv

source .venv/bin/activate

echo "[+] Installing Python dependencies"
pip install --upgrade pip
pip install -r requirements.txt

echo "[+] Enabling scripts"
chmod +x certgen/generate_certs.sh
tls_server/run_server.sh || true
chmod +x tls_server/run_server.sh

echo "[+] Setup complete"
