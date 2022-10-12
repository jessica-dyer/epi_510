## ---------------------------
##
## Script name: EPI 510 R Assignment 2
##
## Purpose of script: Homework 2
##
## Author: Susan Glenn
##
## Date Created: 2022-10-11
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

packages <- c("tidyverse", "lubridate")

new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load packages
invisible(lapply(packages, library, character.only = TRUE))

## Working directory
current_hw_folder <- "hw_2"
directory <- paste("~/Repositories/epi_510/", current_hw_folder, sep = '')
setwd(directory)

## Get data
hw_1_data_cleaning <- "~/Repositories/epi_510/hw_1/HW1_S.Glenn.r"

## Run script from HW 1
source(hw_1_data_cleaning)

## Define new categorical variables
vipcls$momageCat <- ifelse(vipcls$momage <= 19, 1,
                         ifelse(vipcls$momage >19 & vipcls$momage < 30, 2, 
                                ifelse(vipcls$momage >= 30, 3, NA)))


## Create smoke and drink variables
## This says: if cigs1 > 0, write the value 2, but if cigs2 is >0 write the value 3, otherwise, write 1. 
## That should take care of the logic for this question. 
vipcls$smoke <- ifelse(vipcls$cigs2 >0, 3, 
                       ifelse(vipcls$cigs1 > 0, 2, 1))

## Date variables
# There are 20 months/days/years that are NA, those won't parse and these participants won't have enroll_date
vipcls$enroll_date <- as_date(paste(vipcls$enryr, "-", vipcls$enrmo, "-", vipcls$enrdy, sep = ''))
vipcls$delivery_date <- as_date(paste(vipcls$delyr, "-", vipcls$delmo, "-", vipcls$deldy, sep = '')) #610 don't have delivery date info
vipcls$days_btwn_enroll_delivery <- vipcls$delivery_date - vipcls$enroll_date

# Investigate which ptid has a delivery date prior to enrollment
ptid <- vipcls$patid[vipcls$days_btwn_enroll_delivery < 0]
ptid <- ptid[!is.na(ptid)]

## Add labels to new categorical variables
vipcls$momageCat <- factor(vipcls$momageCat, 
                           levels = c(1, 2, 3), 
                           labels = c('<=19', '20-29', '30+'))