"""Demoapp for ITSX26 Security Agent Mesh Lab.

This app is intentionally simple. It is not a production service.
The purpose is to give students something small to test, review and document.
"""

from datetime import datetime, timezone


def build_status_message(service_name: str = "secure-delivery-playground") -> dict:
    """Return a small status object for lab testing."""
    if not service_name or not isinstance(service_name, str):
        raise ValueError("service_name must be a non-empty string")
    return {
        "service": service_name,
        "status": "ok",
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    }


if __name__ == "__main__":
    print(build_status_message())
