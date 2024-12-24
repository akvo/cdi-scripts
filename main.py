from utils.email_service import send_email, MailTypes
import argparse

if __name__ == "__main__":

    def main():
        parser = argparse.ArgumentParser(
            description="Send email with log file."
        )
        parser.add_argument(
            "--email",
            type=str,
            required=True,
            help="Email address to send the log file to",
        )
        args = parser.parse_args()

        send_email(
            args.email, MailTypes.ERROR, "./output-26-11-2024_2000.log"
        )

    if __name__ == "__main__":
        main()
