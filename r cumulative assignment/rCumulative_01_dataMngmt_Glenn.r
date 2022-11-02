## ---------------------------
##
## Script name: EPI 510 R Cumulative Assignment - Data Management 
##
## Purpose of script: R Cumulative Assignment data cleaning
##
## Author: Susan Glenn
##
## Date Created: 2022-10-30
##
## Notes: 
## 1. Data management: brought in and cleaned up data. Data cleaning included: 
##    connecting FIPS codes to each state, setting missing data to NA, 
##    reducing to 10 necessary variables, renaming variables, and creating 
##    logical and factor variables.
## 2. Clean data was saved to "brfss2017Clean.rds" for analysis
## ---------------------------


# Set-up session
# 1b. Clear session and set working directory
rm(list = ls())

wd <- "~/Repositories/epi_510/r cumulative assignment/"
setwd(wd)

# 2a. Load libraries
library(tidyverse)
library(haven)
library(dplyr)

# 2b. Import data
if(!file.exists("data/BRFSS.csv")){
  print("Reading xpt data and writing to csv")
  BRFSSXPT <- read_xpt("data/LLCP2017.XPT_")
  write_csv(BRFSSXPT, "data/BRFSS.csv")
  BRFSS <- read.csv("data/BRFSS.csv")
} else {

# 2c. Write BRFSS data into CSV and read CSV into r
start_time <- Sys.time()
print("Loading csv data.")
BRFSS <- read.csv("data/BRFSS.csv")
end_time <- Sys.time()
time_diff <- end_time-start_time
print(time_diff)
}

# Clean up data
# 3a. Read in the fipsLink.csv file
fipsLink <- read.csv("data/fipsLink.csv")

# 3b. Merge the fipsLink and BRFSS datasets on the FIPS state code, only keeping 
# observations in the BRFSS dataset  
BRFSSMerge <- merge(BRFSS, fipsLink, by.x = "X_STATE", by.y = "fips", all.x = TRUE, all.y = FALSE)

# 3c. Determine merge success by checking missing values
View(fipsLink)
sum(is.na(BRFSSMerge$postalcode))

# 4. View dataset 
glimpse(BRFSSMerge)
View(BRFSSMerge)

# 5. Keep required variables
varsToKeep <- c("name", "postalcode", "X_STATE",  "X_PSU", "X_STSTR", "X_LLCPWT", 
                "SEX", "X_AGEG5YR", "X_AGE65YR", "PHYSHLTH")
BRFSSMerge <- BRFSSMerge[, varsToKeep]
names(BRFSSMerge)

# 6a. View dataset
glimpse(BRFSSMerge)
View(BRFSSMerge)

# 6b. Summarize data and look for impossible or unlikely values.
summary(BRFSSMerge)

# 7a. Rename variables
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
BRFSSMerge$ageBy5[BRFSSMerge$ageBy5 == 14] <- NA
ageBy5FactorLabels <- c("Age 18 to 24", "Age 25 to 29", "Age 30 to 34", "Age 35 to 39", 
                        "Age 40 to 44", "Age 45 to 49", "Age 50 to 54", "Age 55 to 59", 
                        "Age 60 to 64", "Age 65 to 69", "Age 70 to 74", "Age 75 to 79", 
                        "Age 80 or older")
BRFSSMerge$ageBy5Factor <- factor(BRFSSMerge$ageBy5, 
                                  levels = c(1:13), 
                                  labels = ageBy5FactorLabels)
table(BRFSSMerge$ageBy5Factor)
table(BRFSSMerge$ageBy5)

# 7d. Create two versions of the binary variables _age65yr and sex: create a version 
# that is a labelled factor variable coded as 1=65 or older/male, 2=18 to 64/female; 
# and create one logical variable coded as 0=False, 1=True (name this variable 
# either “male” or “female” for sex, and code it accordingly).For all variables, 
# convert all rows with “Don’t know/Refused/Missing” values to missing. 

# Convert _age65yr
# Set Don’t know/Refused/Missing to NA
BRFSSMerge$age65[BRFSSMerge$age65 == 3] <- NA

# Logical 
BRFSSMerge$age65Cat[BRFSSMerge$age65 == 1] <- 0
BRFSSMerge$age65Cat[BRFSSMerge$age65 == 2] <- 1

# Factor
BRFSSMerge$age65Factor[BRFSSMerge$age65 == 2] <- 1
BRFSSMerge$age65Factor[BRFSSMerge$age65 == 1] <- 2

BRFSSMerge$age65Factor <- factor(BRFSSMerge$age65Factor, 
                                   levels = c(1,2),
                                   labels = c("65 or older", "18 to 64"))

#Tabulate to check work on age65 variable
table(BRFSSMerge$age65Factor)
table(BRFSSMerge$age65Cat)

# Convert sex variable
# Set Don’t know/Refused/Missing to NA
BRFSSMerge$sex[BRFSSMerge$sex == 9] <- NA

# Logical 
BRFSSMerge$sexCat[BRFSSMerge$sex == 1] <- 0
BRFSSMerge$sexCat[BRFSSMerge$sex == 2] <- 1

# Factor
BRFSSMerge$sexFactor[BRFSSMerge$sex == 1] <- 1
BRFSSMerge$sexFactor[BRFSSMerge$sex == 2] <- 2

BRFSSMerge$sexFactor <- factor(BRFSSMerge$sexFactor, 
                                 levels = c(1,2),
                                 labels = c("male", "female"))

#Tabulate to check work on sex variable
table(BRFSSMerge$sexFactor)
table(BRFSSMerge$sexCat)

# 7e. Put variables in a sensible order.
BRFSSMerge <- BRFSSMerge %>% select("state", "postCode", "fipsCode", "sex", "sexCat", 
                      "sexFactor", "ageBy5", "ageBy5Factor", "age65", "age65Cat", 
                      "age65Factor", "daysIll", "daysIllCat", "daysIllFactor", 
                      "primSampleUnit", "stratVariable", "phoneData")

# 7f. Save clean dataset as brfss2017Clean.rds
saveRDS(BRFSSMerge, file = "brfss2017Clean.rds")