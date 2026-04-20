#!/usr/bin/env bash
set -euo pipefail

ALGO=$1
DEPTH=$2
OUT=certs/${ALGO}_depth${DEPTH}
CONFIG=certgen/openssl.cnf

rm -rf "$OUT"
mkdir -p "$OUT"

# Root CA
if [ "$ALGO" = "rsa" ]; then
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$OUT/root.key"
elif [ "$ALGO" = "ecdsa" ]; then
  openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:prime256v1 -out "$OUT/root.key"
else
  echo "Unknown algorithm"; exit 1
fi

openssl req -x509 -new -key "$OUT/root.key" -out "$OUT/root.crt" \
  -days 3650 -sha256 -extensions v3_root_ca -config "$CONFIG"

PREV_KEY="$OUT/root.key"
PREV_CRT="$OUT/root.crt"

# Intermediates
for i in $(seq 1 "$DEPTH"); do
  openssl genpkey -algorithm RSA -out "$OUT/int$i.key"
  openssl req -new -key "$OUT/int$i.key" -out "$OUT/int$i.csr" \
    -subj "/CN=Intermediate $i"
  openssl x509 -req -in "$OUT/int$i.csr" -CA "$PREV_CRT" -CAkey "$PREV_KEY" \
    -CAcreateserial -out "$OUT/int$i.crt" -days 3650 -sha256 \
    -extensions v3_intermediate_ca -extfile "$CONFIG"
  PREV_KEY="$OUT/int$i.key"
  PREV_CRT="$OUT/int$i.crt"
done

# Leaf
openssl genpkey -algorithm RSA -out "$OUT/leaf.key"
openssl req -new -key "$OUT/leaf.key" -out "$OUT/leaf.csr" -subj "/CN=localhost"
openssl x509 -req -in "$OUT/leaf.csr" -CA "$PREV_CRT" -CAkey "$PREV_KEY" \
  -CAcreateserial -out "$OUT/leaf.crt" -days 365 -sha256 \
  -extensions v3_leaf -extfile "$CONFIG"

# Chain files
: > "$OUT/chain.pem"
for i in $(seq 1 "$DEPTH"); do
  cat "$OUT/int$i.crt" >> "$OUT/chain.pem"
done

cat "$OUT/root.crt" > "$OUT/ca_bundle.pem"
