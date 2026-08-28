#!/usr/bin/env bash
set -euo pipefail

# Basic defensive checks for the lab repository.
# This script does not scan external targets and does not use secrets.

FAIL=0

check_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "[FAIL] Missing required file: $file"
    FAIL=1
  else
    echo "[OK] Found required file: $file"
  fi
}

echo "== Security Agent Mesh Lab: basic repository checks =="
check_file "README.md"
check_file "app/main.py"
check_file "app/config.example.json"
check_file "docs/01-riskbedomning.md"
check_file "docs/03-ai-anvandning-logg.md"
check_file ".github/workflows/ci.yml"

if grep -R "BEGIN RSA PRIVATE KEY\|BEGIN OPENSSH PRIVATE KEY\|ghp_\|AKIA" . --exclude-dir=.git --exclude="security_check.sh" >/dev/null 2>&1; then
  echo "[WARN] Possible secret-like pattern found. Review results manually."
  FAIL=1
else
  echo "[OK] No common private-key/token patterns found by this simple check."
fi

if grep -R "password *= *['\"]" app scripts tests --include='*.py' >/dev/null 2>&1; then
  echo "[WARN] Possible hardcoded password-like assignment found. Review manually."
  FAIL=1
else
  echo "[OK] No simple hardcoded password assignment found in Python files."
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo "== Result: Review required =="
  exit 1
fi

echo "== Result: Basic checks passed =="
