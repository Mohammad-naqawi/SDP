#!/bin/bash

echo "=============================================="
echo "    ITSX26 - Secure Network & System Check"
echo "=============================================="
echo ""

echo "[+] 1. Samlar grundläggande systeminformation..."
echo "Användare:" && whoami
echo "Värdnamn:" && hostname
echo "Kernel och OS:" && uname -a
echo "Uppetid:" && uptime
echo ""

echo "[+] 2. Kontrollerar identitet och behörigheter (Hardening-kontroll 1)..."
id
echo "Grupper för aktuell användare:"
groups
echo ""

echo "[+] 3. Kontrollerar aktiva nätverksanslutningar och lyssnande portar..."
ss -tuln
echo ""

echo "[+] 4. Visar de första processerna som körs (Processkontroll)..."
ps aux | head -n 10
echo ""

echo "[+] 5. Kontrollerar paketuppdateringar (Systemuppdateringar)..."
if command -v apt &> /dev/null; then
    sudo apt update -y &> /dev/null
    apt list --upgradable 2>/dev/null | head -n 10
else
    echo "APT-pakethanterare hittades inte (ej Debian/Ubuntu-baserat system)."
fi

echo ""
echo "=============================================="
echo "    Kontrollen är slutförd!"
echo "=============================================="
