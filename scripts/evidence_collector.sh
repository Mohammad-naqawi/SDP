#!/usr/bin/env bash
set -euo pipefail

OUT="docs/evidence-summary.txt"
{
  echo "Security Agent Mesh Lab - Evidence Summary"
  echo "Generated: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo
  echo "Repository files:"
  find . -maxdepth 3 -type f | sort | sed 's#^./#- #'
  echo
  echo "Git status, if available:"
  git status --short 2>/dev/null || echo "- Git status not available in this environment"
} > "$OUT"

echo "[OK] Evidence summary written to $OUT"
