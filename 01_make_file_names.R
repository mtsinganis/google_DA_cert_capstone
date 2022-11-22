#######################################
## FUNCTION 'make_file_names'
##
## 'make_file_names' is a function that takes a range of dates in the format
## 'YYYYMM-YYYYMM' and returns a character vector containing the corresponding
## urls to bike trip data .zip files that ca be downloaded from 
## 'https://divvy-tripdata.s3.amazonaws.com/'
#######################################

make_file_names <- function(time_period){
    
    # Check that time_period has format 'YYYYMM-YYYYMM' based on length
    if (str_length(time_period) != 13)
        stop("'time_period' must have length == 13")
    
    # Extract start and end year from 'time_period'
    year_range <- sapply(list(str_sub(time_period, 1, 4),
                              str_sub(time_period, 8, 11)),
                         as.integer)
    
    # Create sequence of all years between start and end year
    year_seq <- seq(year_range[1], year_range[2])
    
    # Given the list of years, generate all possible combination of years+month
    combo <- expand.grid(year = year_seq, month = sprintf('%0.2d', 1:12)) %>% 
        arrange(year) %>% 
        unite("yyyymm", year:month, sep = "") %>% 
        pull(yyyymm) ## pulls column out as character vector
    
    # Split 'time_period' into constituent dates (YYYYMM)
    time_period_split <- str_split(time_period, "-", simplify = TRUE)
    
    # Find the position in 'combo' of the selected start and end dates
    which_combo <- str_which(combo, paste(time_period_split, collapse = "|"))
    
    # Use these two position to subset 'combo' for all dates ranging from start
    # to end date
    combo_subset <- combo[which_combo[1]:which_combo[length(which_combo)]]
    
    # address of bike trip data
    url <- "https://divvy-tripdata.s3.amazonaws.com/"
    
    # Generate list of .zip files to download (based on 'time_period')
    url_list <- str_c(url, combo_subset, "-divvy-tripdata.zip", sep = "")
    
    # Return list as output of function so it can be saved into an object
    return(url_list)
}

## EXAMPLE
#  file_list <- choose_file_by_date("202111-202210")