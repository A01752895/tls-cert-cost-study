#!/usr/bin/env bash
set -e

echo "[+] TLS Certificate Cost Study – Full Run"

./setup.sh

source .venv/bin/activate

echo "[+] Running experiments"
python experiments/run_experiments.py

echo "[+] Generating plots"
python analysis/plot_results.py

echo "[+] DONE"

echo "Results:"
echo "  data/results.csv"
echo "  figures/latency.png"
