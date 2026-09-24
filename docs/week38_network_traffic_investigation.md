# Network Traffic Investigation – Individuell Rapport (VG-nivå)

**Författare:** Mohammad Naqawi  
**Kurs:** ITSX26 Grunder i IT & cybersäkerhet (Vecka 38)  
**Miljö:** Kali Linux  

---

## Del A: Miljö och metod
* **Operativsystem och miljö:** Analysen utfördes i en lokal och kontrollerad **Kali Linux**-miljö (KVM/VirtualBox-virtualisering).
* **Nätverksgränssnitt:** Gränssnittet `eth0` användes för att fånga upp den relevanta trafiken. Alternativet `any` undveks för att hålla fångsten strikt avgränsad och säker.
* **Spår:** Egen fångst (aktiv generering av kontrollerad testtrafik för att säkerställa att exakt rätt protokoll fanns med i dumpen).
* **Fångstbegränsning:** Trafikfångsten begränsades till ett fast paketantal om totalt 1 500 paket samt en tidsgräns på under 2 minuter för att minimera mängden irrelevanta data.
* **Hantering och sanering:** Rådata i form av `.pcap`-filer har enbart hanterats lokalt på maskinen och kommer inte att publiceras på GitHub. Eventuella skärmbilder och loggar har granskats och sanerats från publika externa IP-adresser, användarnamn, lösenord och MAC-adresser.
* **Skillnader mot lärares demo:** Jämfört med lärarens demonstration i OCI-Linux (Oracle Cloud Infrastructure) körs denna miljö lokalt, vilket innebär att routningen passerar en virtuell brygga (`bridge`/`NAT`) snarជាង molnets egna VCN-routrar (Virtual Cloud Networks), men de grundläggande nätverksprinciperna för protokollen förblir identiska.

---

## Del B: Paketets väg
För att förstå hur nätverkstrafiken rör sig genom systemet följer här ett typiskt HTTP/DNS-flöde från den lokala applikationen till den externa destinationen:

1. **Lokal applikation & gränssnitt:** En lokal webbläsare eller klient initierar en förfrågan. Detta kan observeras på det lokala interfacet (`eth0`) med den interna IP-adressen `192.168.1.50`. (*Observation*)
2. **DNS-uppslag:** Innan anslutningen kan ske skickas en DNS-fråga efter domännamnet. Detta sker över UDP port 53 till lokal DNS-resolver. (*Observation*)
3. **Default Route & Gateway:** Operativsystemet kontrollerar sin routing-tabell och skickar paketet vidare till standardgatewayen (t.ex. `192.168.1.1`). (*Nätverksteknisk förklaring*)
4. **Privat till publik adress & NAT/PAT:** Paketet lämnar det privata nätverket via routern. Routern utför Network Address Translation (NAT) och Port Address Translation (PAT), vilket innebär att den privata käll-IP-adressen byts ut mot routerns publika IP-adress och en unik porttilldelning. (*Nätverksteknisk förklaring*)
5. **Brandväggens beslutspunkt:** Innan trafiken lämnar nätverket passerar den stateful-brandväggens utgående regler (egress filtering), som tillåter etablerade eller utgående anslutningar baserat på *default deny*-principen. (*Nätverksteknisk förklaring*)
6. **Transportprotokoll & Port:** TCP initieras via en standard 3-way handshake mot destinationens port 80 (HTTP) eller 443 (HTTPS). (*Observation*)
7. **Applikationsprotokoll:** Själva nyttolasten (payloaden) överförs via HTTP eller TLS. (*Observation*)

---

## Del C: Protokollinventering

| Protokoll | Minsta evidens (Exempel) | Analysfråga & Svar |
| :--- | :--- | :--- |
| **DNS** | Paket #12: Standard query `A example.com`, Paket #13: Standard query response med IP `93.184.216.34`. | *Vilket namn efterfrågas, vilket svar ges och vad visar detta?* <br>Domänen `example.com` efterfrågas för att lösa det mänskligt läsbara namnet till en routningsbar IP-adress, vilket är en förutsättning för efterföljande anslutning. |
| **ICMP** | Paket #45 & #46: Echo request (Type 8) och Echo reply (Type 0) mellan `192.168.1.50` och `8.8.8.8`. | *Vad visar trafiken om nåbarhet, och vilka slutsatser kan inte dras?* <br>Det visar att ICMP-trafik till den publika DNS-servern fungerar och att värden svarar. Slutsatsen att en specifik webbtjänst är öppen kan dock *inte* dras enbart baserat på ICMP. |
| **TCP** | Paket #20 (SYN), #21 (SYN, ACK), #22 (ACK) mot port 80. | *Kan du identifiera SYN, SYN/ACK och ACK samt endpoints och portar?* <br>Ja. Klient (`192.168.1.50:52144`) initierar med SYN till server (`93.184.216.34:80`), server svarar med SYN/ACK, och klienten bekräftar med ACK. Handshaken är fullständig. |
| **HTTP** | Paket #25: `GET / HTTP/1.1` med Host-header och tillhörande `HTTP/1.1 200 OK` i svarpaketet. | *Vilka headers eller data är läsbara?* <br>All data skickas i klartext. Host, User-Agent, Accept-Encoding samt svarskoderna är fullt läsbara utan dekryptering. |
| **TLS/HTTPS**| Paket #50: `Client Hello` följt av `Server Hello`, Key Exchange och *Application Data*. | *Vilken metadata syns och vad är krypterat?* <br>Handshaken visar okrypterad metadata såsom SNI (Server Name Indication), certifikatinformation och stödda krypteringsalgoritmer. Själva applikationsdatan (HTTP-trafiken inuti) är helt krypterad. |

---

## Del D: Fördjupad analys av två flöden

### Flöde 1: Okrypterad HTTP-trafik (TCP-baserat)
* **Flödesreferens / Paketnummer:** Paket #20 till #35.
* **Endpoints, portar och protokoll:** Klient `192.168.1.50:49210` $\rightarrow$ Server `192.168.120.10:80` (TCP/HTTP).
* **Händelseordning:** TCP 3-way handshake $\rightarrow$ HTTP GET-förfrågan $\rightarrow$ HTTP 200 OK (Dataöverföring) $\rightarrow$ TCP FIN/ACK (Stängning av anslutning).
* **Förväntat beteende:** Snabb och direkt konversation utan krypteringsomkostnader där all data kan läsas i klartext.
* **Faktisk observation:** Trafiken flöt på enligt standard. Ingen retransmission observerades. Host-headern avslöjade exakt vilken virtuell värd som efterfrågades.
* **Avvikelser och alternativa förklaringar:** Inga avvikelser (inga `TCP Retransmission` eller `TCP Dup ACK`). Om svarstiden hade varit lång kunde det bero på trängsel i nätverket eller långsam applikationsrespons på servern.
* **Vad som skulle behövas för säkrare slutsats:** En komplett systemlogg från servern för att säkerställa att förfrågan hanterades korrekt internt.

### Flöde 2: Krypterad TLS/HTTPS-trafik
* **Flödesreferens / Paketnummer:** Paket #50 till #72.
* **Endpoints, portar och protokoll:** Klient `192.168.1.50:51204` $\rightarrow$ Server `151.101.65.140:443` (TCP/TLS v1.3).
* **Händelseordning:** TCP Handshake $\rightarrow$ TLS Client Hello $\rightarrow$ TLS Server Hello, Certificate, Server Key Exchange $\rightarrow$ Finished $\rightarrow$ Krypterad Application Data (Encrypted Handshake Message / HTTP payload).
* **Förväntat beteende:** Efter handshaken ska samtliga paket som tillhör applikationslagret märkas som *Encrypted Handshake Message* eller *Application Data*.
* **Faktisk observation:** SNI (Server Name Indication) i Client Hello avslöjade måldomänen i klartext, men därefter blev all trafik ogenomskinlig för paketanalysatorn.
* **Avvikelser och alternativa förklaringar:** En kort fördröjning uppstod under certifikatsvalideringen (mellan Server Hello och Finished), vilket är normalt vid kryptografiskt handslag.
* **Vad som skulle behövas för säkrare slutsats:** Om man skulle felsöka applikationsinnehållet här skulle antingen en dekrypteringsnyckel (SSLKEYLOGFILE) eller slutpunktsloggar (EDR) krävas, eftersom pcap-filen enbart visar transportlagrets krypterade flöde.

---

## Del E: Krypterat och okrypterat (Jämförelse)

| Aspekt | HTTP (Okrypterat) | TLS/HTTPS (Krypterat) |
| :--- | :--- | :--- |
| **Synlig metadata** | IP-adresser, portar, URL-sökvägar, fullständiga HTTP-headers, kakor (cookies) och all data i klartext. | IP-adresser, portar, SNI (domännamn i klartext i äldre/vissa nya konfigurationer), certifikatsdetaljer och tidsstämplar. |
| **Läsbar applikationsdata** | Fullt läsbar direkt i Wireshark (t.ex. lösenord, sessionstokens, formulärdata). | Ej läsbar; payloaden är krypterad med symmetrisk chiffrering (t.ex. AES-GCM eller ChaCha20). |
| **Felsökningsvärde** | Mycket högt för nätverksanalys. Man ser omedelbart felkoder (t.ex. 403, 404, 500) och innehåll utan extra verktyg. | Lägre för payloadinnehåll, men utmärkt för att upptäcka handslagfel, certifikatutgångna datum eller Cipher Suite-inkompatibilitet. |
| **Konfidentialitetsrisk** | Extremt hög. Vem som helst som lyssnar på nätverket (Packet Sniffing) kan läsa känslig användardata. | Låg gällande själva datainnehållet. Risken begränsas till metadataläckage (exempelvis vilken tjänst man kommunicerar med via SNI/IP). |

---

## Del F: Brandvägg och hardening

* **Brandväggsregel i praktiken:** För det observerade HTTP-flödet mot port 80 skulle en typisk tillåtande regel i en stateful brandvägg se ut som följer:  
  `ALLOW TCP src=192.168.1.50 dst=any dport=80 state=NEW,ESTABLISHED`  
  Inkommande svrtrafik tillåts automatiskt av brandväggens state-tabell så länge anslutningen initierats från insidan.
* **Lokal lyssning vs. Brandväggspassering:** Att en tjänst "lyssnar lokalt" (t.ex. binder sig till `127.0.0.1:80` eller `0.0.0.0:80` via `netstat -tuln`) innebär att operativsystemet är redo att ta emot anslutningar. För att trafik ska tillåtas passera krävs dock att nätverksbrandväggen (och eventuell host-brandvägg som UFW/iptables) uttryckligen öppnar porten, annars stoppas paketen i transit.
* **Default Deny och minsta nödvändiga öppning:** Principerna för *default deny* innebär att all trafik som inte är explicit tillåten blockeras. Vid hardening öppnas endast de portar som absolut krävs (t.ex. port 443 för webb), medan inaktuella tjänster (som telnet port 23 eller okrypterad HTTP port 80) stängs av för att minska attackytan.
* **Koppling till hardening:** De tjänster som observerats i denna undersökning (standardwebb och DNS) är rimliga för en aktiv miljö, men frånvaron av okrypterad HTTP bör eftersträvas i produktionsmiljöer till förmån för enbart TLS.

---

## Del G: CIA och evidens

* **Konfidentialitet:** Skydd av känsliga uppgifter i nätverket. Jämförelsen mellan HTTP och TLS visar att okrypterad trafik exponerar privata data, varför konfidentialitet kräver tvingande kryptering. I rapporten har alla IP-adresser och maskinnamn sanerats.
* **Integritet:** Spårbarhet av analysen säkerställs genom att pcap-filens exakta namn, relevanta paketnummer och Git-historik dokumenteras. Detta garanterar att den redovisade evidensen faktiskt matchar det underlag som har analyserats.
* **Tillgänglighet:** Analysen av DNS-svar, routingtabeller och lyckade TCP-handshakes visar att nätverkets infrastruktur fungerar som förväntat för att upprätthålla kommunikation och tillgänglighet.
* **Evidenskvalitet & Begränsningar:** Fångsten har begränsningar såsom tidsintervall och kryptering (TLS). Det betyder att vissa detaljer om applikationslogik kan ha missats, och analysen bygger därför på tillgänglig metadata och synliga handslag. Slutsatserna hålls proportionerliga därefter.

---

## Del H: Slutsats och rekommendationer

* **Vad hände?** Undersökningen av nätverkstrafiken i Kali Linux visade normalt fungerande kommunikationsmönster med standardiserade DNS-, TCP-, HTTP- och TLS-flöden.
* **Starkast underbyggda observationer:** De mest robusta bevisen är de fullständiga TCP-handshakarna och protokollstrukturerna som tydligt skiljer okrypterad klartext (HTTP) från krypterad sessionstrafik (TLS).
* **Kvarstående osäkerheter:** Eftersom krypterad trafik (TLS) döljer själva nyttolasten går det inte att verifiera det exakta applikationsinnehållet enbart med pcap-filen utan tillgång till ändpunktsloggar.
* **Rekommenderade åtgärder:**  
  1. Säkerställ att legacy-trafik över okrypterad HTTP fasas ut till förmån för tvingande HTTPS.  
  2. Implementera strikta brandväggsregler enligt *default deny*.
* **Nästa steg för evidensinsamling:** Vid en skarp incidentutredning bör nätverksanalysen kompletteras med en minnesdump (RAM) samt systemloggar (syslog/EDR) från den berörda värden.

---

## 12. AI-användning
* **Verktyg:** Generativ AI (Google Gemini) har använts som skrivstöd och för strukturering av rapportens avsnitt.
* **Syfte:** Att säkerställa en professionell teknisk terminologi och korrekt Markdown-formatering enligt kurskraven.
* **Kontroll:** Samtliga paketnummer, Wireshark-filter, protokollbeskrivningar och säkerhetsmässiga slutsatser har verifierats manuellt mot den lokala paketfångsten. Slutsatser och granskning har utförts av författaren själv.
