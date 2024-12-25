# import schedule
# import time
# import os
from jobs.job_01_check_datasets import check_datasets


def job():
    if check_datasets():
        # download_data()
        # if run_cdi():
        #     run_aggregation()
        #     upload_outputs()
        print("Success: All jobs completed.")
        # else:
        #     print("Error: Missing data, NDMC scripts not run.")
    else:
        print("No updates available.")


if __name__ == '__main__':
    job()

    # while True:
    #     schedule.run_pending()
    #     time.sleep(1)

# schedule.every().month.do(job)

# while True:
#     schedule.run_pending()
#     time.sleep(1)
