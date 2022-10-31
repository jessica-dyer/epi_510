## ---------------------------
##
## Script name: EPI 510 R Cumulative Assignment
##
## Purpose of script: R Cumulative Assignment
##
## Author: Susan Glenn
##
## Date Created: 2022-10-30
##
## Notes: 
## 1. Data management: bring in and clean up data. Data cleaning included: 
##    connecting FIPS codes to each state, reducing columns to 10 necessary variables, 
##    renaming variables, 
## 2. 
## ---------------------------

# Set-up session
## 1b. Clear session and set working directory
rm(list = ls())

wd <- "~/Repositories/epi_510/r cumulative assignment/"
setwd(wd)

## 2a. Load libraries
library(tidyverse)
library(haven)

## 2b. Import data
if(!file.exists("data/BRFSS.csv")){
  print("Reading xpt data and writing to csv")
  BRFSSXPT <- read_xpt("data/LLCP2017.XPT_")
  write_csv(BRFSSXPT, "data/BRFSS.csv")
  BRFSS <- read.csv("data/BRFSS.csv")
} else {
  ## 2c. Write BRFSS data into CSV and read CSV into r
  start_time <- Sys.time()
  print("Loading csv data.")
  BRFSS <- read.csv("data/BRFSS.csv")
  end_time <- Sys.time()
  time_diff <- end_time-start_time
  print(time_diff)
}

# Clean up data
## 3a. Read in the fipsLink.csv file
fipsLink <- read.csv("data/fipsLink.csv")

## 3b. Merge the fipsLink and BRFSS datasets on the FIPS state code, only keeping observations in the BRFSS dataset  
BRFSSMerge <- merge(BRFSS, fipsLink, by.x = "X_STATE", by.y = "fips", all.x = TRUE, all.y = FALSE)

## 3c. Determine merge success by checking missing values
View(fipsLink)
is.na(BRFSSMerge$postalcode)

## 4. View dataset 
glimpse(BRFSSMerge)
View(BRFSSMerge)

## 5. Keep required variables 
BRFSSMerge <- BRFSSMerge[, c("name", "postalcode", "X_STATE",  "X_PSU", "X_STSTR", "X_LLCPWT", "SEX", "X_AGEG5YR", "X_AGE65YR", "PHYSHLTH")]
names(BRFSSMerge)

## 6a. View dataset
glimpse(BRFSSMerge)
View(BRFSSMerge)

## 6b. Summarize data and look for impossible or unlikely values.
summary(BRFSSMerge)

## 7a. Rename variables
colnames(BRFSSMerge)[1] ="state"
colnames(BRFSSMerge)[2] ="postCode"
colnames(BRFSSMerge)[3] ="fipsCode"
colnames(BRFSSMerge)[4] ="primSampleUnit"
colnames(BRFSSMerge)[5] ="stratVariable"
colnames(BRFSSMerge)[6] ="phoneData"
colnames(BRFSSMerge)[7] ="sex"
colnames(BRFSSMerge)[8] ="ageBy5"
colnames(BRFSSMerge)[9] ="age65"
colnames(BRFSSMerge)[10] ="daysIll"

##7b. Convert all values corresponding to “Don’t know/Not sure” and “Refused” to NA for physhlth. Create two binary versions of variable: one factor variable coded as 1 = 15 or more days, and 2 = <15 days; and one logical version of each using 0/1 coding (0 = <15 days and 1 = 15+ days)
BRFSSMerge[BRFSSMerge == 77] <- NA
BRFSSMerge[BRFSSMerge == 99] <- NA

BRFSSMerge$daysIll[BRFSSMerge$daysIll <15] <- 0
BRFSSMerge$daysIll[BRFSSMerge$daysIll ==88] <- 0
BRFSSMerge$daysIll[BRFSSMerge$daysIll >=15] <- 1

BRFSSMerge$daysIllFactor <- factor(BRFSSMerge$daysIllFactor, 
                            levels = 0:1,
                            labels = c("15 or more days", "2 = <15 days"))
