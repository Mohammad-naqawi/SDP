# Security Agent Mesh Lab: Secure Delivery Playground

**Repo-skelett v0.3**  
**ITSX26 Kurs 1: Grunder i IT och cybersäkerhet**  
**Syfte:** Ge en praktisk, defensiv och pedagogisk introduktion till DevSecOps, säkerhetskontroller, dokumentation och ansvarsfull AI-användning.

---

## 1. Vad du ska göra

I den här labben ska du arbeta med ett litet demo-repository som visar hur säkerhet kan byggas in i ett utvecklings- och leveransflöde.

Du ska:

1. Förstå repo-strukturen.
2. Läsa och tolka en enkel pipeline.
3. Köra eller granska Bash- och Python-baserade säkerhetskontroller.
4. Dokumentera risker och säkerhetsåtgärder.
5. Använda AI som stöd, men verifiera och förklara med egna ord.
6. Koppla observationer till CIA-triaden och CIS Controls.
7. Lämna in labbrapport, riskbedömning, AI-logg och reflektion.

---

## 2. Repo-struktur

```text
secure-delivery-playground/
├── app/
│   ├── main.py
│   └── config.example.json
├── tests/
│   └── test_basic.py
├── scripts/
│   ├── security_check.sh
│   ├── basic_config_check.py
│   └── evidence_collector.sh
├── docs/
│   ├── 01-riskbedomning.md
│   ├── 02-cis-controls-mappning.md
│   ├── 03-ai-anvandning-logg.md
│   ├── 04-labbrapport.md
│   ├── 05-reflektion.md
│   └── simulated-alerts.md
├── agent-prompts/
│   ├── product-agent.md
│   ├── security-agent.md
│   ├── threat-agent.md
│   ├── compliance-agent.md
│   ├── guardrails-agent.md
│   └── evidence-agent.md
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── security-check.yml
│   │   └── evidence.yml
│   └── ISSUE_TEMPLATE/
│       ├── feature.md
│       ├── security-review.md
│       └── risk-observation.md
├── dependabot.yml
├── requirements.txt
├── .gitignore
└── LICENSE
```

---

## 3. Snabbstart lokalt

> Obs: Följ alltid lärarens instruktioner om vilken miljö som ska användas.

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m pytest
bash scripts/security_check.sh
python scripts/basic_config_check.py
```

---

## 4. Labbflöde

| Moment | Fil/stöd | Vad du gör |
|---|---|---|
| Labb 0 | `docs/05-reflektion.md` | Orientering och säkerhetsmindset |
| Labb 1 | `.github/workflows/ci.yml` | Förstå pipeline |
| Labb 2 | `scripts/` | Köra/tolka säkerhetskontroller |
| Labb 3 | `docs/01-riskbedomning.md`, `docs/02-cis-controls-mappning.md` | Risk och CIS Controls |
| Labb 4 | `docs/simulated-alerts.md` | Dependency och supply chain-reflektion |
| Labb 5 | `docs/03-ai-anvandning-logg.md` | AI-stöd och kritisk verifiering |
| Labb 6 | `agent-prompts/guardrails-agent.md` | Guardrails vid ändring |
| Labb 7 | `docs/04-labbrapport.md` | Evidence och slutrapport |

---

## 5. Säkerhetsregler

Den här labben är defensiv och kontrollerad.

Du ska inte:

- angripa externa mål,
- testa mot verkliga system,
- använda riktiga hemligheter eller tokens,
- hantera verkliga personuppgifter,
- skapa eller köra skadlig kod,
- genomföra offensiva moment utanför lärarens instruktioner.

---

## 6. AI-policy

AI får användas som stöd för att förstå begrepp, tolka scripts, felsöka och formulera reflektioner. AI får inte ersätta din egen förståelse.

Dokumentera alltid:

- vad du frågade,
- vilket svar du fick,
- vad du kontrollerade själv,
- vad du ändrade eller valde bort,
- vilken slutsats du drog.

---

## 7. Slutleverabler

Lämna in följande:

- `docs/01-riskbedomning.md`
- `docs/02-cis-controls-mappning.md`
- `docs/03-ai-anvandning-logg.md`
- `docs/04-labbrapport.md`
- `docs/05-reflektion.md`

**Kom ihåg:** Säkerhet är en del av arbetssättet, inte en kontroll på slutet.
