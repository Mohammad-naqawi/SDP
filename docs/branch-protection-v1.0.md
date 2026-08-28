# Branch protection v1.0

## Rekommenderad regel för `main`

Mål: `main`

Aktivera:

- Require a pull request before merging.
- Require approvals: 1.
- Dismiss stale approvals when new commits are pushed, om kursens arbetssätt kräver omgranskning efter ändring.
- Require status checks to pass before merging.
- Require branches to be up to date before merging, om GitHub-miljön stödjer det och det inte skapar onödig friktion för utbildningsmiljön.
- Required status checks:
  - `test`
  - `basic-security-checks`
- Require conversation resolution before merging.
- Block force pushes.
- Block deletion.

## Pedagogisk kommentar

Skyddet ska användas för att visa ett professionellt arbetssätt. För studenternas egna forks kan reglerna hållas enklare. Lärarens canonical repo bör däremot skyddas så att `main` representerar kursens stabila version.
