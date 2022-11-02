## ---------------------------
##
## Script name: EPI 510 R Cumulative Assignment - BRFSS Data Analysis
##
## Purpose of script: R Cumulative Assignment data analysis
##
## Author: Susan Glenn
##
## Date Created: 2022-11-01
##
## Notes: 
## 
## 
## ---------------------------

# 8a. Set-up session - clear memory, set working directory, load libraries
rm(list = ls())
wd <- "~/Repositories/epi_510/r cumulative assignment/"
setwd(wd)

library(tidyverse)
library(haven)
library(naniar)
library(dplyr)

# 8b. Read in the clean rds version 
cleanBRFSSdata <- readRDS(file = "brfss2017Clean.rds")

# 8c. Apply the summary function to the full dataset 
summary(cleanBRFSSdata)

# Missingness analysis
png("data/missingness.png")
vis_miss(cleanBRFSSdata, warn_large_data = FALSE)
dev.off()