#!/bin/bash
# check-env.sh — Verifies all keys from .env.example exist in the actual .env

ENV_EXAMPLE=""
ENV_ACTUAL=""

for f in .env.example .env.sample .env.template; do
  [ -f "$f" ] && ENV_EXAMPLE="$f" && break
done

for f in .env .env.local .env.development .env.dev; do
  [ -f "$f" ] && ENV_ACTUAL="$f" && break
done

if [ -z "$ENV_EXAMPLE" ]; then
  echo "No .env.example found — nothing to check against"
  exit 0
fi

if [ -z "$ENV_ACTUAL" ]; then
  echo "ERROR: No .env file found. Copy $ENV_EXAMPLE and fill the values."
  exit 1
fi

echo "=== ENV CHECK ==="
echo "Reference : $ENV_EXAMPLE"
echo "Actual    : $ENV_ACTUAL"
echo ""

MISSING=0
while IFS= read -r line; do
  [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
  KEY=$(echo "$line" | cut -d= -f1)
  if ! grep -q "^${KEY}=" "$ENV_ACTUAL" 2>/dev/null; then
    echo "MISSING: $KEY"
    MISSING=$((MISSING + 1))
  fi
done < "$ENV_EXAMPLE"

if [ "$MISSING" -eq 0 ]; then
  echo "All variables present — env is complete"
else
  echo ""
  echo "$MISSING variable(s) missing from $ENV_ACTUAL"
  exit 1
fi
