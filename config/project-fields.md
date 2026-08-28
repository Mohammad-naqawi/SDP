# GitHub Projects - fält och vyer v1.0

## Rekommenderade fält

| Fält | Typ | Exempelvärden |
|---|---|---|
| Status | Single select | Backlog, Pågår, Behöver stöd, Klar för granskning, Godkänd, Komplettering |
| Labbmoment | Single select | Labb 0, Labb 1, Labb 2, Labb 3, Labb 4, Labb 5, Labb 6, Labb 7 |
| Agentroll | Single select | Product, Security, Threat, Compliance, Guardrails, Evidence |
| Prioritet | Single select | Hög, Medel, Låg |
| Bedömningsstatus | Single select | Ej påbörjad, Pågår, Inlämnad, Granskad, Komplettering, Godkänd |
| Workshopblock | Single select | Block 1, Block 2, Fördjupning |

## Rekommenderade vyer

### Student Backlog

Board grupperad på `Status`, filtrerad på labb-labels.

### Agent Mesh View

Board grupperad på `Agentroll`, filtrerad på `agent:*`.

### Assessment View

Table med fält för student/grupp, labbmoment, bedömningsstatus och kompletteringsbehov.

### Roadmap View

Roadmap eller timeline baserad på milestones: Workshopblock 1, Workshopblock 2 och Studentinlämningar.
