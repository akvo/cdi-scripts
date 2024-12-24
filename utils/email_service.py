import os
import base64
from enum import Enum
from .mailjet_client import get_mailjet_client


class MailTypes(Enum):
    SUCCESS = "success"
    ERROR = "error"
    MISSING = "missing"


def get_html_content(mail_type: MailTypes) -> str:
    template_path = f'utils/templates/{mail_type.value}.html'
    with open(template_path, 'r') as file:
        return file.read()


def send_email(to, mail_type: MailTypes, attachment: str):
    mailjet = get_mailjet_client()

    with open(attachment, 'rb') as file:
        encoded_content = base64.b64encode(file.read()).decode('utf-8')

    if mail_type == MailTypes.SUCCESS:
        subject = "Success Notification"
        text_part = "This is a success notification."
    elif mail_type == MailTypes.ERROR:
        subject = "Error Notification"
        text_part = "This is an error notification."
    elif mail_type == MailTypes.MISSING:
        subject = "Missing Notification"
        text_part = "This is a missing notification."

    html_part = get_html_content(mail_type)

    data = {
        'Messages': [
            {
                "From": {
                    "Email": os.getenv(
                        "MAILJET_DEFAULT_SENDER", "noreply@akvo.org"
                    ),
                },
                "To": [
                    {
                        "Email": to,
                    }
                ],
                "Subject": subject,
                "TextPart": text_part,
                "HTMLPart": html_part,
                "Attachments": [
                    {
                        "ContentType": "text/plain",
                        "Filename": attachment.split('/')[-1],
                        "Base64Content": encoded_content
                    }
                ]
            }
        ]
    }

    result = mailjet.send.create(data=data)
    return result
