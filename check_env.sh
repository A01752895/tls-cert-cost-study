#!/usr/bin/env bash
set -e

echo "[+] Checking system requirements"

command -v python3 >/dev/null 2>&1 || {
  echo "[-] python3 not found"; exit 1; }

command -v openssl >/dev/null 2>&1 || {
  echo "[-] openssl not found"; exit 1; }

PYV=$(python3 - <<'EOF'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")
EOF
)

echo "[+] Python version: $PYV"

echo "[+] OpenSSL version:" 
openssl version

echo "[+] Environment looks OK"
