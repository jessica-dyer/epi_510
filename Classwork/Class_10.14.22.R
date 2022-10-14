## ---------------------------
##
## Script name: EPI 510 R Classwork
##
## Purpose of script: Classwork
##
## Author: Susan Glenn
##
## Date Created: 2022-10-14
##
## ---------------------------

## Set working directory
current_hw_folder <- "hw_2"
directory <- paste("~/Repositories/epi_510/", current_hw_folder, sep = '')
setwd(directory)

## Get data
vipcls <- readRDS(file = "~/Repositories/epi_510/vipcls.rds")

#extract month data
table(format(vipcls$del_date, "%m"))
table(format(vipcls$del_date, "%B"))

