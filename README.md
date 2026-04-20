# TLS Certificate Verification Cost Study

This repository provides an empirical, black-box study of the **real operational cost** of validating X.509 certificate chains during TLS handshakes.

## Research Question

> What is the operational cost of TLS certificate verification under different cryptographic algorithms (RSA vs ECDSA) and different certificate chain lengths?

## What is measured

- TLS handshake latency
- Bytes exchanged during the handshake
- Scalability as the certificate chain grows

## Methodology

- No cryptographic simulation
- Real certificates generated with OpenSSL
- Real TLS server (`openssl s_server`)
- Real TLS client (`openssl s_client`)
- Python used only for automation and measurement

## Repository structure

See subdirectories for certificate generation, TLS server, client, experiments, and analysis.

## How to run (after download)

```bash
python experiments/run_experiments.py --config experiments/configs.yaml
python analysis/plot_results.py --input data/results.csv --output-dir figures
