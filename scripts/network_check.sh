#!/bin/bash

# ==============================================================================
# Skriptnamn: secure_network_check.sh
# Syfte: Säkert nätverks- och systemkontrollverktyg för Linuxmiljö (VG-version)
# Säkerhetsavgränsning: Endast mot localhost och egen miljö. Ingen extern scanning.
# ==============================================================================

# 1. Variabler
LOG_DIR="./evidence"
LOG_FILE="$LOG_DIR/network_check_$(date +%Y%m%d_%H%M%S).log"
TEST_PORT=8080
SUCCESS_COUNT=0
FAIL_COUNT=0

# Skapa loggkatalog om den inte finns
mkdir -p "$LOG_DIR"

# 2. Loggnings- och statusfunktion (Krav: funktion + statusar INFO, OK, WARN, FAIL)
log_message() {
    local status="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    local formatted_msg="[$timestamp] [$status] $message"
    echo -e "$formatted_msg"
    echo "$formatted_msg" >> "$LOG_FILE"

    # Räkna upp lyckade/misslyckade för sammanfattning
    if [ "$status" = "OK" ] || [ "$status" = "INFO" ]; then
        ((SUCCESS_COUNT++))
    elif [ "$status" = "WARN" ] || [ "$status" = "FAIL" ]; then
        ((FAIL_COUNT++))
    fi
}

# 3. Cleanup-funktion (Krav: Stoppa egen testtjänst / rensa tempfiler)
cleanup() {
    log_message "INFO" "Utför uppstädning (cleanup)..."
    if [ -n "$SERVER_PID" ]; then
        kill "$SERVER_PID" 2>/dev/null
        log_message "OK" "Stoppade tillfällig lokal webbserver (PID: $SERVER_PID)."
    fi
}
trap cleanup EXIT

# 4. Miljööversikt (Obligatorisk funktion)
check_environment() {
    log_message "INFO" "Kontrollerar miljö och nätverksadresser..."
    if command -v ip &> /dev/null; then
        local ip_output
        ip_output=$(ip -br address)
        log_message "OK" "Hittade nätverksinterface:\n$ip_output"
    else
        log_message "FAIL" "Kommandot 'ip' saknas."
    fi
}

# 5. DNS-kontroll (Obligatorisk funktion + Krav: kontroll av ogiltigt värde)
check_dns() {
    local target="localhost"
    log_message "INFO" "Verifierar DNS/namnuppslag för: $target"
    
    if getent hosts "$target" &> /dev/null; then
        log_message "OK" "DNS-uppslag lyckades för $target."
    else
        log_message "FAIL" "DNS-uppslag misslyckades för $target."
    fi
}

# 6. Lokal tjänstekontroll (Obligatorisk funktion med tillfällig webbserver)
check_local_service() {
    log_message "INFO" "Startar tillfällig lokal testtjänst på port $TEST_PORT..."
    python3 -m http.server "$TEST_PORT" --bind 127.0.0.1 &> /dev/null &
    SERVER_PID=$!
    sleep 1

    if curl -s "http://127.0.0.1:$TEST_PORT" > /dev/null; then
        log_message "OK" "Den lokala tjänsten svarar korrekt på port $TEST_PORT."
    else
        log_message "FAIL" "Kunde inte nå den lokala tjänsten på port $TEST_PORT."
    fi
}

# 7. Portöversikt (Obligatorisk funktion med 'ss' och loop)
check_ports() {
    log_message "INFO" "Sammanfattar lokalt lyssnande portar..."
    if command -v ss &> /dev/null; then
        local listening_ports
        listening_ports=$(ss -tuln)
        log_message "OK" "Aktiva lyssnande portar:\n$listening_ports"
    else
        log_message "FAIL" "Kommandot 'ss' är inte tillgängligt."
    fi
}

# 8. Huvudloop över kontroller (Krav: loop över en definierad lista med säkra kontroller)
run_checks() {
    log_message "INFO" "Startar exekvering av säkerhetskontroller..."
    
    local checks=("environment" "dns" "local_service" "ports")
    for check in "${checks[@]}"; do
        case "$check" in
            environment) check_environment ;;
            dns) check_dns ;;
            local_service) check_local_service ;;
            ports) check_ports ;;
        esac
    done
}

# Kör huvudflödet
run_checks

# 9. Slutsammanfattning (Krav: visa antal lyckade/misslyckade och var loggen finns)
echo "=================================================="
log_message "INFO" "KONTROLL SLUTFÖRD. Sammanfattning:"
echo -e "Lyckade/Info-statusar: $SUCCESS_COUNT"
echo -e "Varningar/Fel-statusar: $FAIL_COUNT"
echo -e "Loggfil sparad till: $LOG_FILE"
echo "=================================================="

# Exit-kod baserat på fel
if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
else
    exit 0
fi
