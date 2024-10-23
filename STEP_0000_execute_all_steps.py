# -*- coding: utf-8 -*-
from netCDF4 import Dataset
from STEP_0101_read_hdf_create_LST_anom_netcdf import main as step_0101
from STEP_0102_read_hdf_create_NDVI_anom_netcdf import main as step_0102
from STEP_0103_read_chirps_create_precip_netcdf_and_spi_netcdf import main as step_0103
from STEP_0104_create_5km_soil_moisture_netcdf import main as step_0104
from STEP_0201_percent_rank_LST_anom_netcdf import main as step_0201
from STEP_0202_percent_rank_NDVI_anom_netcdf import main as step_0202
from STEP_0203_percent_rank_SPI_anom import main as step_0203
from STEP_0204_percent_rank_soil_moisture_netcdf import main as step_0204
from STEP_0301_CDI_weighted_sum import main as step_0301
from STEP_0302_percent_rank_CDI_weighted_sum import main as step_0302
from STEP_0303_export_ranking_data_rasters import main as step_0303
from argparse import ArgumentParser

"""
Use anaconda 3.7 virtual environment
Packages:
    conda: h5py
    conda: netCDF4
    conda: imageio
    conda: scipy
    conda: rasterio
"""


def main(args):
    print("Executing Step 0101...")
    step_0101(args)
    print("Executing Step 0102...")
    step_0102(args)
    print("Executing Step 0103...")
    step_0103(args)
    print("Executing Step 0104...")
    step_0104(args)
    print("Executing Step 0201...")
    step_0201()
    print("Executing Step 0202...")
    step_0202()
    print("Executing Step 0203...")
    step_0203()
    print("Executing Step 0204...")
    step_0204()
    print("Executing Step 0301...")
    step_0301()
    print("Executing Step 0302...")
    step_0302()
    print("Executing Step 0303...")
    step_0303(args)
    print("Finished processing CDI data")


if __name__ == '__main__':
    # set up the command line argument parser
    parser = ArgumentParser()
    parser.add_argument("-m", "--mode", default="updates",
                        help="The mode of the current processing: updates or all. Default is updates")
    # execute the programs with the supplied options
    main(parser.parse_args())
