import os
import subprocess
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv(os.path.join(os.path.dirname(__file__), "../../.env"))

DOWNLOAD_CHIRPS_BASE_URL = os.getenv("DOWNLOAD_CHIRPS_BASE_URL")
DOWNLOAD_CHIRPS_PATTERN = os.getenv("DOWNLOAD_CHIRPS_PATTERN")
DOWNLOAD_LST_BASE_URL = os.getenv("DOWNLOAD_LST_BASE_URL")
DOWNLOAD_LST_PATTERN = os.getenv("DOWNLOAD_LST_PATTERN")
DOWNLOAD_NDVI_BASE_URL = os.getenv("DOWNLOAD_NDVI_BASE_URL")
DOWNLOAD_NDVI_PATTERN = os.getenv("DOWNLOAD_NDVI_PATTERN")
DOWNLOAD_SM_BASE_URL = os.getenv("DOWNLOAD_SM_BASE_URL")
DOWNLOAD_SM_PATTERN = os.getenv("DOWNLOAD_SM_PATTERN")

DATA_DIR = os.path.join(os.path.dirname(__file__), "../../data")
DOWNLOADED_FILES_PATHS = {
    "chirps": os.path.join(DATA_DIR, "chirps_downloaded_files.txt"),
    "lst": os.path.join(DATA_DIR, "lst_downloaded_files.txt"),
    "ndvi": os.path.join(DATA_DIR, "ndvi_downloaded_files.txt"),
    "sm": os.path.join(DATA_DIR, "sm_downloaded_files.txt"),
}


def get_downloaded_files(dataset):
    path = DOWNLOADED_FILES_PATHS[dataset]
    if not os.path.exists(path):
        with open(path, "w") as file:
            pass  # Create an empty file if it does not exist
    with open(path, "r") as file:
        return [line.strip() for line in file.readlines()]


def get_available_files(url, pattern="tif"):
    command = (
        f'curl -s "{url}" | grep "{pattern}" | pup | grep -v "href" '
        f'| grep "{pattern}" | sed "s/ //g"'
    )
    result = subprocess.run(
        command, shell=True, capture_output=True, text=True
    )
    if result.returncode == 0:
        return result.stdout.splitlines()
    return []


def check_dataset(base_url, pattern, dataset):
    downloaded_files = get_downloaded_files(dataset)
    available_files = get_available_files(base_url, pattern)

    if len(downloaded_files) == 0:
        with open(DOWNLOADED_FILES_PATHS[dataset], "w") as file:
            for item in available_files:
                file.write(item + "\n")
        return True

    new_files = [
        file for file in available_files if file not in downloaded_files
    ]

    if new_files:
        print(f"New files for {dataset}: {new_files}")
        return True
    return False


def check_chirps():
    return check_dataset(
        DOWNLOAD_CHIRPS_BASE_URL,
        DOWNLOAD_CHIRPS_PATTERN,
        "chirps"
    )


def check_lst():
    return check_dataset(DOWNLOAD_LST_BASE_URL, DOWNLOAD_LST_PATTERN, "lst")


def check_ndvi():
    return check_dataset(DOWNLOAD_NDVI_BASE_URL, DOWNLOAD_NDVI_PATTERN, "ndvi")


def check_sm():
    return check_dataset(DOWNLOAD_SM_BASE_URL, DOWNLOAD_SM_PATTERN, "sm")


def check_datasets():
    download_chirps = check_chirps()
    return download_chirps
    # download_lst = check_lst()
    # download_ndvi = check_ndvi()
    # download_sm = check_sm()
    # return (download_chirps, download_lst, download_ndvi, download_sm)
