#!/usr/bin/env bash
set -e

CERT_DIR=$1
PORT=$2
PROTO=$3

FLAG=""
[ "$PROTO" = "tls1_2" ] && FLAG="-tls1_2"
[ "$PROTO" = "tls1_3" ] && FLAG="-tls1_3"

openssl s_server \
  -accept "$PORT" \
  -cert "$CERT_DIR/leaf.crt" \
  -key "$CERT_DIR/leaf.key" \
  -cert_chain "$CERT_DIR/chain.pem" \
  $FLAG -www
