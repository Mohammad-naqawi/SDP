# Simulerade alerts för labben

Dessa alerts är pedagogiska exempel. De ska användas för analys och dokumentation, inte för offensiv testning.

## Simulerat dependency-alert

**Rubrik:** Paketet `example-lib` använder en äldre version.  
**Risk:** En äldre dependency kan innehålla kända sårbarheter eller sakna viktiga säkerhetsfixar.  
**Uppgift:** Beskriv hur teamet bör resonera innan en uppdatering accepteras.

Frågor:

- Vilka tester bör köras?
- Vilka delar av applikationen kan påverkas?
- Hur dokumenterar du beslutet?

## Simulerat code scanning-alert

**Rubrik:** Konfigurationsfil innehåller placeholder för secret.  
**Risk:** Om riktiga secrets råkar committas kan konfidentialitet påverkas.  
**Uppgift:** Förklara varför riktiga secrets inte ska lagras i repositoryt.

Frågor:

- Vilken del av CIA-triaden påverkas främst?
- Hur kan teamet förebygga detta?
- Hur kan en pipeline hjälpa till?
