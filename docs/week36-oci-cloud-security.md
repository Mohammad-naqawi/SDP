# Week 36 OCI Cloud Security Lab (Local VirtualBox Edition)

## 1. Min OCI-miljö/Min lokala Linux-miljö/Min lokala WSL-miljö
- Tenancy (N/A): N/A (Lokal miljö)
- Compartment (Endast OCI): N/A
- Region (Endast OCI): N/A
- Availability Domain (Endast OCI): N/A
- VM-namn/hostnamn/WSL-maskinnamn: itsx26-local-vm
- Operativsystem: Ubuntu 22.04.4 LTS
- Shape (Hårdvara, gäller alla): 2 vCPU, 2 GB RAM, 25 GB Disk (VirtualBox Virtual Machine)
- Inloggningsmetod: SSH via lokal portforwarding / NAT (ssh user@127.0.0.1 -p 2222)

---

## 2. Linux-kommandon
| Kommando | Vad visar det? | CIA-koppling |
|-----------|-----------|-----------|
| whoami | Visar användarnamnet för den inloggade användaren. | Konfidentialitet & Autentisering |
| hostname | Visar maskinens nätverkshostnamn. | Tillgänglighet & Identifikation |
| pwd | Visar den absoluta sökvägen till den aktuella katalogen (Print Working Directory). | Integritet (koll på var filer hanteras) |
| uname -a | Visar detaljerad systeminformation inklusive kärnversion (kernel) och arkitektur. | Integritet & Systemöversikt |
| uptime | Visar hur länge systemet har varit igång, antal inloggade användare samt systemets genomsnittliga belastning (load average). | Tillgänglighet |

---

## 3. Hardening
| Kontroll | Risk | Vad gjorde jag? | Hur verifierade jag? | CIA |
|-----------|-----------|-----------|-----------|-----------|
| Identitet & Behörigheter | Obehöriga får root-behörighet eller kör med fel konton. | Undersökte vilka grupper min användare tillhörde och säkerställde att jag inte kör som root i onödan. | Körde `whoami`, `id` och `groups`. | Konfidentialitet & Integritet |
| Filrättigheter | Känsliga filer läses eller ändras av alla användare på systemet. | Skapade en testfil (`touch test.txt`) och begränsade dess rättigheter med `chmod 600 test.txt`. | Körde `ls -l test.txt` för att verifiera att endast ägaren har läs- och skrivrättigheter (-rw-------). | Konfidentialitet |
| Systemuppdateringar | Sårbarheter i mjukvara utnyttjas av angripare. | Sökte efter tillgängliga uppdateringar via pakethanteraren. | Körde `sudo apt update` och `apt list --upgradable`. | Integritet & Tillgänglighet |
| Processkontroll | Dolda eller skadliga processer körs i bakgrunden utan uppsikt. | Listade aktiva processer för att kontrollera att inga okända tjänster körs. | Körde `ps aux | head` för att inspektera processlistan. | Integritet & Tillgänglighet |

---

## 4. Recovery-plan
### Vad kan gå fel?
- SSH-tjänsten kraschar, brandväggen blockerar anslutningar, eller lösenordet/nyckeln förloras.
### Hur upptäcker jag problemet?
- Det går inte att upprätta anslutning från host-datorn (`Connection refused` eller `Connection timed out`).
### Vad kontrollerar jag först?
- Att den virtuella maskinen är igång i VirtualBox-gränssnittet och att nätverksinställningarna/port forwarding är intakta.
### Hur återställer jag åtkomst?
- Logga in direkt via VirtualBox konsol för att felsöka nätverk, starta om SSH-daemonen (`sudo systemctl restart ssh`) eller återställa filer.
### När behöver jag hjälp?
- Om filsystemet är korrupt eller om virtuella diskar har skadats bortom enkel reparation.

---

## 5. Backup
### Vad har jag sparat?
- Konfigurationsfiler, dokumentation och skript.
### Vad finns i GitHub?
- All dokumentation (denna rapport) samt versionshanterade skript.
### Vad kan återskapas?
- Hela rapportstrukturen och källkoden i GitHub-repot samt konfigurationer dokumenterade i text.
### Vad går inte att återskapa?
- Specifika binära filer eller temporära loggar som enbart låg på den virtuella diskens runtime-miljö om en total krasch sker.

---

## 6. Cleanup
### VM-instans
- Stäng av maskinen i VirtualBox och välj "Power off the machine".
### Diskar
- Kontrollera att virtuella diskar rensas om maskinen tas bort permanent.
### Backuper
- Inga externa backuper behövde sparas för denna tillfälliga labbmiljö.
### Publika IP-adresser
- Ej tillämpligt (lokal VirtualBox-miljö, inga publika molnresurser nyttjades).
### GitHub-evidens
- Säkerställ att mappen `docs/` med filen `week36-oci-cloud-security.md` är sparad i repositoryt.

---

## 7. CIA-reflektion
### Konfidentialitet
- Genom att begränsa filbehörigheter (`chmod 600`) och skydda inloggningsuppgifter säkerställs att endast behöriga kan läsa känslig data.
### Integritet
- Regelbundna uppdateringar och kontroll av processer och systemfiler garanterar att systemet inte har modifierats av obehöriga.
### Tillgänglighet
- Att förstå grundläggande recovery och backup säkerställer att tjänster snabbt kan komma online igen vid driftstopp.

---

## 8. Reflektion
### Vad fungerade bra?
- Att sätta upp och konfigurera den virtuella maskinen i VirtualBox och köra kommandona.
### Vad var svårt?
- Att strukturera upp alla säkerhetskontroller och koppla dem korrekt till CIA-triaden.
### Vad lärde jag mig?
- Jag har fått en tydligare förståelse för hur man administrerar en lokal Linux-miljö, arbetar med filrättigheter och tänker kring säkerhetshärdning och återställning.
