#######################################
## SCRIPT
##
## This script sources the custom function 'make_file_names' to generate a list
## of urls pointing to the .zip files in the online directory containing bike
## trip data. It then uses that list to download the corresponding .zip files, 
## stores them in a subfolder of the main working directory called 'raw_data', 
## and finally extracts the .csv files, saving them in the same subfolder. 

#######################################
# 0 - Load libraries
#######################################
library(stringr) # 'str_* functions are utilized in 'make_file_names' function
library(dplyr)   # several 'dplyr' functions are utilized in 'make_file_names'
library(tidyr)   # for 'unite' function
library(here)    # here() function for path specification


#######################################
# 1 - Source function
#######################################
source(file = "01_make_file_names.R")


#######################################
# 2 - Code
#######################################
# Generate list of .zip files to be downloaded based on desired date range
file_list <- make_file_names("202111-202210")

# Create new subdirectory to store the 'raw_data'
dir.create(here('raw_data'))

# Iteratively apply download.file() function to url list. Invisible() suppresses
# the output of sapply since it is not useful
invisible(sapply(file_list,
                 function(url) {
                     download.file(url, here('raw_data', basename(url)))
                     }))

# Generate vector of full paths to .zip files downloaded in 'raw_data' subfolder
zip_file_path <- file.path(here("raw_data"), list.files(here("raw_data")))

# Iteratively extract .csv files and store them in the 'raw_data' subfolder
invisible(sapply(zip_file_path,
                 function(x) unzip(x, unzip(x, list = TRUE)$Name[1],
                                   exdir = here("raw_data"))))

# Delete all .zip files from subfolder, keeping only the .csv files
invisible(sapply(zip_file_path, function(m) unlink(m)))
