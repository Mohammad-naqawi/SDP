# GitHub-konfiguration v1.0

**Security Agent Mesh Lab: Secure Delivery Playground**  
**ITSX26 Kurs 1: Grunder i IT och cybersäkerhet**  
**Syfte:** Göra GitHub-repot kursklart med labels, milestones, Projects, branch protection, pull request-guardrails och Copilot/agentiskt arbetssätt på pedagogisk nivå.

---

## 1. Förutsättning

Den här konfigurationen utgår från att repo-skelettet redan finns i GitHub, exempelvis:

```text
itsx26-security-agent-mesh-lab
```

Du behöver ha rättigheter att administrera repot för att kunna skapa labels, milestones, Projects och branch protection.

---

## 2. Rekommenderad GitHub-struktur

| Område | Rekommendation |
|---|---|
| Standardbranch | `main` |
| Arbetsbrancher | `feature/<kort-namn>`, `lab/<student-eller-grupp>`, `docs/<kort-namn>` |
| Pull requests | Alla ändringar till `main` går via PR |
| Status checks | `CI` och `Basic security checks` ska passera innan merge |
| Dokumentation | Studenternas arbete styrs via `docs/`-mallarna |
| AI/agentiskt stöd | Copilot/AI får användas som stöd, men ändringar kräver mänsklig granskning |

---

## 3. Labels

Skapa labels enligt `config/labels.csv` eller `config/labels.md`.

### Import med GitHub CLI, exempel

```bash
while IFS=',' read -r name color description; do
  if [ "$name" != "name" ]; then
    gh label create "$name" --color "$color" --description "$description" --force
  fi
done < config/labels.csv
```

---

## 4. Milestones

Skapa milestones enligt `config/milestones.md`.

Rekommenderade milestones:

1. `v0.3 Repo-skelett`
2. `v0.4 Lärarpaket`
3. `v1.0 Kursklar labb`
4. `Workshopblock 1`
5. `Workshopblock 2`
6. `Studentinlämningar`

---

## 5. GitHub Projects

Skapa tre projektvyer eller tre separata Projects beroende på hur Chas/TechSeed vill arbeta.

### Project A: Student Backlog

Syfte: visa studenternas labbflöde.

Kolumner eller statusfält:

```text
Backlog
Pågår
Behöver stöd
Klar för granskning
Godkänd
Komplettering
```

### Project B: Security Agent Mesh

Syfte: visa agentroller och säkerhetsflöden.

Gruppera på labels:

```text
agent:product
agent:security
agent:threat
agent:compliance
agent:guardrails
agent:evidence
```

### Project C: Kursutveckling

Syfte: hålla reda på utvecklingen från v0.3 till v1.0.

Status:

```text
Planerat
Under arbete
Behöver beslut
Redo för kurs
Stängt
```

---

## 6. Branch protection för `main`

Rekommenderade regler för `main`:

- Require a pull request before merging.
- Require at least one approving review.
- Require status checks before merging.
- Required checks:
  - `test`
  - `basic-security-checks`
- Require conversation resolution before merging.
- Block force pushes.
- Block deletion of protected branch.

Om studenter arbetar i egna forks kan skyddet hållas främst på lärarens canonical repo.

---

## 7. Pull request-process

Alla ändringar till `main` ska svara på:

- Vad har ändrats?
- Vilken labb eller agentroll berörs?
- Har tester körts?
- Har säkerhetskontroller körts?
- Finns dokumentation eller AI-logg om AI har använts?
- Finns några risker eller avgränsningar?

Se `.github/pull_request_template.md`.

---

## 8. Copilot/agentiskt arbetssätt

Copilot eller annan AI ska inte vara bedömningssubjekt. AI används som lärandestöd och som simulerad agentisk arbetsform.

Rekommenderad policy:

- AI får föreslå, förklara och strukturera.
- Studenten måste verifiera och dokumentera.
- Alla AI-stödda ändringar måste kunna förklaras av studenten.
- AI-genererad kod eller text får inte mergas utan mänsklig review.
- Om Copilot coding agent används ska uppgifter vara låg- till medelkomplexa och PR:er granskas av människa.

Se `docs/copilot-agent-policy-v1.0.md`.

---

## 9. Rekommenderad första uppsättning issues

Skapa issues från mallarna i `.github/ISSUE_TEMPLATE/`:

1. `[Feature] Labb 0: Orientering och säkerhetsmindset`
2. `[Feature] Labb 1: Pipelineförståelse`
3. `[Security Review] Labb 2: Bash/Python-kontroller`
4. `[Risk] Labb 3: Riskbedömning och CIS Controls`
5. `[Risk] Labb 4: Dependency och supply chain-case`
6. `[Security Review] Labb 5: Code scanning och AI-stöd`
7. `[Security Review] Labb 6: Guardrails vid Pull Request`
8. `[Feature] Labb 7: Evidence och slutrapport`

---

## 10. Definition of Done

En labbdel är klar när:

- relevanta tester/kontroller har körts eller tolkats,
- risker och åtgärder är dokumenterade,
- AI-logg finns om AI har använts,
- studenten kan förklara resultatet med egna ord,
- läraren kan följa observation -> risk -> åtgärd -> evidens.

Se `docs/definition-of-done-v1.0.md`.
