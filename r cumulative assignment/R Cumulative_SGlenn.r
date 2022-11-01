## ---------------------------
##
## Script name: EPI 510 R Cumulative Assignment
##
## Purpose of script: R Cumulative Assignment data cleaning
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
library(naniar)

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
sum(is.na(BRFSSMerge$postalcode))

## 4. View dataset 
glimpse(BRFSSMerge)
View(BRFSSMerge)

## 5. Keep required variables
varsToKeep <- c("name", "postalcode", "X_STATE",  "X_PSU", "X_STSTR", "X_LLCPWT", "SEX", "X_AGEG5YR", "X_AGE65YR", "PHYSHLTH")
BRFSSMerge <- BRFSSMerge[, varsToKeep]
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

# 7b. Convert all values corresponding to “Don’t know/Not sure” and “Refused” to 
# NA for physhlth. Create two binary versions of variable: one factor variable 
# coded as 1 = 15 or more days, and 2 = <15 days; and one logical version of each 
# using 0/1 coding (0 = <15 days and 1 = 15+ days)
BRFSSMerge$daysIll[BRFSSMerge$daysIll == 77] <- NA
BRFSSMerge$daysIll[BRFSSMerge$daysIll == 99] <- NA

# Logical 
BRFSSMerge$daysIllCat[BRFSSMerge$daysIll <15] <- 0
BRFSSMerge$daysIllCat[BRFSSMerge$daysIll >=15] <- 1

# Factor
BRFSSMerge$daysIllFactor[BRFSSMerge$daysIll >= 15] <- 1
BRFSSMerge$daysIllFactor[BRFSSMerge$daysIll < 15] <- 2

BRFSSMerge$daysIllFactor <- factor(BRFSSMerge$daysIllFactor, 
                            levels = c(1,2),
                            labels = c("15 or more days", "<15 days"))

# 7c. Convert ageBy5 to a labelled factor variable as noted in data dictionary page 163
ageBy5FactorLabels <- c("Age 18 to 24", "Age 25 to 29", "Age 30 to 34", "Age 35 to 39", 
                        "Age 40 to 44", "Age 45 to 49", "Age 50 to 54", "Age 55 to 59", 
                        "Age 60 to 64", "Age 65 to 69", "Age 70 to 74", "Age 75 to 79", 
                        "Age 80 or older", "Don’t know/Refused/Missing")
BRFSSMerge$ageBy5Factor <- factor(BRFSSMerge$ageBy5, 
                                  levels = c(1:14), 
                                  labels = ageBy5FactorLabels)

# 7e. 
#columnOrder <- c("state", "fipsCode")
#BRFSSMerge <- BRFSSMerge[, columnOrder]

# Missingness analysis
png("data/missingness.png")
vis_miss(BRFSSMerge, warn_large_data = FALSE)
dev.off()