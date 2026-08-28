from app.main import build_status_message


def test_build_status_message_default():
    result = build_status_message()
    assert result["service"] == "secure-delivery-playground"
    assert result["status"] == "ok"
    assert "timestamp_utc" in result


def test_build_status_message_custom_name():
    result = build_status_message("student-lab")
    assert result["service"] == "student-lab"


def test_build_status_message_rejects_empty_name():
    try:
        build_status_message("")
    except ValueError as exc:
        assert "service_name" in str(exc)
    else:
        raise AssertionError("Expected ValueError")
