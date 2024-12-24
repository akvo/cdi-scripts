import os
import requests
from dotenv import load_dotenv

load_dotenv()
geonode_url = os.getenv("GEONODE_URL")
username = os.getenv("GEONODE_USERNAME")
password = os.getenv("GEONODE_PASSWORD")
dataset_path = os.getenv("DATASET_PATH")
dataset_type = os.getenv("DATASET_TYPE")

# List of cateogries ids in Geonode
categories = {
    "cdi": 22,
    "lst": 23,
    "ndvi": 24,
    "spi": 25,
}


def write_failure_message(response):
    print("Request failed.")
    print("Status Code:", response.status_code)
    print("Response:", response.text)


def upload_to_geonode(base_file_path, xml_file_path=None, sld_file_path=None):
    api_url = f"{geonode_url}api/v2/uploads/upload?format=json"
    files = {
        "base_file": open(base_file_path, "rb"),
    }
    if xml_file_path:
        files["xml_file"] = open(xml_file_path, "rb")
    if sld_file_path:
        files["sld_file"] = open(sld_file_path, "rb")
    data = {
        "store_spatial_files": False,
        "overwrite_existing_layer": True,
        "skip_existing_layers": False,
    }
    response = requests.post(
        api_url,
        auth=(username, password),
        files=files,
        data=data
    )
    if response.status_code == 201:
        json_response = response.json()
        return json_response.get("execution_id")
    else:
        write_failure_message(response)
        return None


def get_all_dataset_files():
    dataset_files = []
    for root, dirs, files in os.walk(dataset_path):
        for file in files:
            if file.endswith(dataset_type):
                dataset_files.append(os.path.join(root, file))
    return dataset_files


def update_dataset_metadata(dataset_id, metadata):
    api_url = f"{geonode_url}api/v2/datasets/{dataset_id}"
    response = requests.patch(
        api_url,
        auth=(username, password),
        json=metadata
    )
    if response.status_code == 200:
        print("Upload dataset successful!")
    else:
        write_failure_message(response)


def tracking_upload_progress(execution_id: int, taxonomy: str):
    if not execution_id:
        return
    api_url = f"{geonode_url}api/v2/executionrequest/{execution_id}"
    response = requests.get(api_url, auth=(username, password))
    if response.status_code == 200:
        json_response = response.json()["request"]
        if json_response.get("status") != "finished":
            tracking_upload_progress(execution_id, taxonomy)
        else:
            dataset = json_response.get("output_params").get("resources")[0]
            if dataset.get("id"):
                update_dataset_metadata(
                    dataset["id"],
                    {
                        "advertised": False,
                        "is_published": False,
                        "category": categories.get(taxonomy),
                    },
                )
    else:
        write_failure_message(response)
        return None


# def create_category(taxonomy):
#     api_url = f"{geonode_url}api/v2/keywords/"
#     category_name = f"{taxonomy.lower()}-ratser-map"
#     category_description = f"{taxonomy} Raster Map"
#     response = requests.post(
#         api_url,
#         auth=(username, password),
#         json={"name": category_name,  "description": category_description}
#     )
#     if response.status_code == 201:
#         print(f"Category {category_name} created successfully!")
#     else:
#         write_failure_message(response)


def main():
    dataset_files = get_all_dataset_files()
    for dataset_file in dataset_files:
        print(f"Uploading {dataset_file} to GeoNode...")
        execution_id = upload_to_geonode(dataset_file)
        taxonomy = dataset_file.split('/')[-2]
        tracking_upload_progress(
            execution_id,
            taxonomy.lower()
        )


if __name__ == '__main__':
    main()
