"""Basic local config check for ITSX26 lab.

This script validates the example configuration file only. It does not connect to
any external system and does not process real secrets.
"""

import json
from pathlib import Path

CONFIG_PATH = Path("app/config.example.json")


def main() -> int:
    if not CONFIG_PATH.exists():
        print(f"[FAIL] Missing {CONFIG_PATH}")
        return 1

    data = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    failures = []

    if data.get("debug") is not False:
        failures.append("debug should be false in the example config")

    if data.get("environment") != "lab":
        failures.append("environment should be 'lab'")

    secret_value = data.get("secret_value", "")
    if "REPLACE_WITH_LOCAL_VALUE" not in secret_value:
        failures.append("secret_value should remain a placeholder in committed example config")

    if not data.get("use_demo_data_only"):
        failures.append("use_demo_data_only should be true")

    if failures:
        print("[FAIL] Config review required:")
        for item in failures:
            print(f" - {item}")
        return 1

    print("[OK] Example config passed basic checks")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
