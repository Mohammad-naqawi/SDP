#!/usr/bin/env bash
set -euo pipefail

# Exempelkommandon. Kör från roten av repot efter gh auth login.
# Anpassa OWNER/REPO innan körning om du inte står i rätt repo.

# 1. Skapa labels från config/labels.csv
while IFS=',' read -r name color description; do
  if [ "$name" != "name" ]; then
    gh label create "$name" --color "$color" --description "$description" --force
  fi
done < config/labels.csv

# 2. Skapa milestones manuellt via GitHub UI eller med gh api.
# GitHub CLI har varierande stöd beroende på version, därför lämnas detta som UI-rekommendation i config/milestones.md.

# 3. Kontrollera workflows
ls .github/workflows
