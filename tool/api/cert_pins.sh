#!/usr/bin/env bash
# Prints the base64 SHA-256 SPKI pin of every certificate a server sends, for
# --dart-define=CERT_PINS (use the leaf plus the intermediate as the backup).
#
# Usage (Git Bash): tool/api/cert_pins.sh api.mattel-dev.altimeda.com
set -euo pipefail
host="${1:?usage: cert_pins.sh <host>}"
dir="$(mktemp -d)"
echo | openssl s_client -connect "$host:443" -servername "$host" -showcerts 2>/dev/null \
  | awk -v d="$dir" '/BEGIN CERT/{n++} n{print > (d "/c" n ".pem")}'
for f in "$dir"/c*.pem; do
  subject="$(openssl x509 -in "$f" -noout -subject)"
  expires="$(openssl x509 -in "$f" -noout -enddate)"
  pin="$(openssl x509 -in "$f" -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl base64)"
  echo "$subject"
  echo "  $expires"
  echo "  pin: $pin"
done
rm -rf "$dir"
