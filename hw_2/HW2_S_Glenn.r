## ---------------------------
##
## Script name: 
##
## Purpose of script:
##
## Author: 
##
## Date Created: 
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

library(lubridate)
install.packages("lubridate")

## Working directory
current_hw_folder <- "hw_2"
directory <- paste("~/Repositories/epi_510/", current_hw_folder, sep = '')
setwd(directory)

## Get data
hw_1_data_cleaning <- "~/Repositories/epi_510/hw_1/HW1_S.Glenn.r"
source(hw_1_data_cleaning)

## Define new categorical variables
vipcls$momageCat <- ifelse(vipcls$momage <= 19, 1,
                         ifelse(vipcls$momage >19 & vipcls$momage < 30, 2, 
                                ifelse(vipcls$momage >= 30, 3, NA)))


## Create smoke and drink variables
vipcls$smoke <- ifelse(vipcls$cigs1 >0, 2, 
                       ifelse(vipcls$cigs2 > 0, 3, 1))

## Date variables
# There are some months/days/years that are NA, those won't parse. 
vipcls$enroll_date <- as_date(paste(vipcls$enryr, "-", vipcls$enrmo, "-", vipcls$enrdy, sep = ''))

## Add labels to new categorical variables
vipcls$momageCat <- factor(vipcls$momageCat, 
                           levels = c(1, 2, 3), 
                           labels = c('<=19', '20-29', '30+'))