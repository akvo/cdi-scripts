import pytest
from utils.email_service import send_email, MailTypes
from unittest.mock import patch, mock_open


@pytest.fixture
def mock_mailjet_client():
    with patch("utils.email_service.get_mailjet_client") as mock_client:
        yield mock_client


@pytest.fixture
def mock_file():
    with patch(
        "builtins.open", mock_open(read_data=b"This is a test file.")
    ) as mock_file:  # Return bytes
        yield mock_file


@pytest.fixture
def mock_base64_encode():
    with patch(
        "base64.b64encode", return_value=b"VGhpcyBpcyBhIHRlc3QgZmlsZS4="
    ) as mock_encode:  # Return bytes
        yield mock_encode


@pytest.fixture
def mock_html_content():
    with patch(
        "utils.email_service.get_html_content",
        return_value="<h3>Mock HTML Content</h3>",
    ) as mock_html:
        yield mock_html


def test_send_email_success(mock_mailjet_client, mock_file, mock_html_content):
    mock_mailjet_client.return_value.send.create.return_value.status_code = 200
    mock_mailjet_client.return_value \
        .send.create.return_value.json.return_value = {
            "Messages": [{"Status": "success"}]
        }

    response = send_email(
        "recipient_email@example.com",
        MailTypes.SUCCESS,
        "./logs/cdi-202310_24122024.txt",
    )

    assert mock_mailjet_client.return_value.send.create.called
    assert response.status_code == 200
    assert response.json() == {"Messages": [{"Status": "success"}]}


def test_send_email_error(mock_mailjet_client, mock_file, mock_html_content):
    mock_mailjet_client.return_value.send.create.return_value.status_code = 200
    mock_mailjet_client.return_value\
        .send.create.return_value.json.return_value = {
            "Messages": [{"Status": "error"}]
        }

    response = send_email(
        "recipient_email@example.com",
        MailTypes.ERROR,
        "./logs/success-202310_24122024.txt"
    )

    assert mock_mailjet_client.return_value.send.create.called
    assert response.status_code == 200
    assert response.json() == {"Messages": [{"Status": "error"}]}


def test_send_email_missing(mock_mailjet_client, mock_file, mock_html_content):
    mock_mailjet_client.return_value.send.create.return_value.status_code = 200
    mock_mailjet_client.return_value \
        .send.create.return_value.json.return_value = {
            "Messages": [{"Status": "missing"}]
        }

    response = send_email(
        "recipient_email@example.com",
        MailTypes.MISSING,
        "./logs/cdi-202310_24122024.txt"
    )

    assert mock_mailjet_client.return_value.send.create.called
    assert response.status_code == 200
    assert response.json() == {"Messages": [{"Status": "missing"}]}
