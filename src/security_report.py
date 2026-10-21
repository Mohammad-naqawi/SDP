from collections import Counter
import os

def load_suspicious_ips(filepath="data/suspicious_ips.txt"):
    """Läser in IOC-lista med misstänkta IP-adresser."""
    suspicious = set()
    if not os.path.exists(filepath):
        return suspicious
    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            ip = line.strip()
            if ip and not ip.startswith("#"):
                suspicious.add(ip)
    return suspicious

def analyze_auth_log(filepath="data/auth.log"):
    """Analyserar auth.log för misslyckade inloggningsförsök."""
    failed_attempts = Counter()
    total_lines = 0
    parsed_lines = 0
    skipped_lines = 0
    
    if not os.path.exists(filepath):
        return failed_attempts, total_lines, parsed_lines, skipped_lines

    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            total_lines += 1
            parts = line.strip().split(",")
            if len(parts) < 3:
                skipped_lines += 1
                continue  # Hanterar formatfel
            parsed_lines += 1
            timestamp, ip, status = parts[0], parts[1], parts[2]
            if status == "FAILED":
                failed_attempts[ip] += 1
                
    return failed_attempts, total_lines, parsed_lines, skipped_lines

def analyze_access_log(filepath="data/access.log"):
    """Analyserar access.log för webbtrafik."""
    access_hits = Counter()
    total_lines = 0
    parsed_lines = 0
    skipped_lines = 0

    if not os.path.exists(filepath):
        return access_hits, total_lines, parsed_lines, skipped_lines

    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            total_lines += 1
            parts = line.strip().split(",")
            if len(parts) < 4:
                skipped_lines += 1
                continue  # Hanterar formatfel
            parsed_lines += 1
            ip = parts[1]
            access_hits[ip] += 1

    return access_hits, total_lines, parsed_lines, skipped_lines

def generate_report():
    suspicious_ips = load_suspicious_ips()
    auth_failed, auth_total, auth_parsed, auth_skipped = analyze_auth_log()
    access_hits, access_total, access_parsed, access_skipped = analyze_access_log()
    
    os.makedirs("output", exist_ok=True)
    report_path = "output/security_report.txt"
    
    report_content = []
    report_content.append("=== SECURITY AUTOMATION REPORT (G-NIVÅ) ===")
    report_content.append("Genomförd analys av auth.log och access.log.\n")
    
    report_content.append("1. DATAKÄLLOR OCH STATISTIK")
    report_content.append(f"- auth.log: {auth_total} rader totalt, {auth_parsed} godkända, {auth_skipped} felaktiga.")
    report_content.append(f"- access.log: {access_total} rader totalt, {access_parsed} godkända, {access_skipped} felaktiga.\n")
    
    report_content.append("2. OBSERVATIONER (MISSLYCKADE INLOGGNINGAR)")
    report_content.append("IP-adress | Misslyckade försök | IOC-matchning")
    report_content.append("-" * 50)
    for ip, count in auth_failed.most_common():
        match_status = "Träff i IOC" if ip in suspicious_ips else "Ej i IOC"
        report_content.append(f"{ip:<15} | {count:<18} | {match_status}")
        
    report_content.append("\n3. OBSERVATIONER (WEBBTRAFIK)")
    report_content.append("IP-adress | Antal anrop | IOC-matchning")
    report_content.append("-" * 50)
    for ip, count in access_hits.most_common():
        match_status = "Träff i IOC" if ip in suspicious_ips else "Ej i IOC"
        report_content.append(f"{ip:<15} | {count:<11} | {match_status}")
        
    report_content.append("\n4. BEGRÄNSNINGAR")
    report_content.append("- En träff i IOC-listan innebär endast att adressen förekommer i listan, inte att en bekräftad attack har skett.")
    
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("\n".join(report_content))
        
    print(f"Rapport genererad i {report_path}")

if __name__ == "__main__":
    generate_report()
