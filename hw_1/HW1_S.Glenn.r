## ---------------------------
## Script name: Epi 510 HW 1
##
## Purpose of script: Homework 1
##
## Author: Susan Glenn
##
## Date Created: 2022-10-03
## ---------------------------

# Set-up session

## 1a. Change WD to Epi 510
wd <- "~/Repositories/epi_510/hw_1"
setwd(wd)

## 1b. Create a data frame by reading data from "vipcls.csv"
vipcls <- read.csv("vipcls.csv")

# Examine the data

## 2a. View dataset:
View(vipcls)

## 2b. Type of data:
class(vipcls)

## 2c. Names of fields: 
column_names <- names(vipcls)
print(column_names)

## 2d. Dimensions of data:
dim(vipcls)

## 2e. Structure of vipcls
str(vipcls)

## 2f. Summary of data:
summary(vipcls)

# Data Cleaning

## 3a. Set missing data to NA
vipcls[vipcls == -1] <- NA

## 3b. Set mother’s age (momage) of ≤15 to missing
vipcls$momage[vipcls$momage <= 15] <- NA

## 3c. Set gestational age (delges) above 52 to missing
vipcls$delges[vipcls$delges > 52] <- NA

## 3d. Set birth weight of babies (bw) below 300 to missing
vipcls$bw[vipcls$bw < 300] <- NA

## 3e. Set birth weight of babies (bw) 6000 and above to missing
vipcls$bw[vipcls$bw >= 6000] <- NA

# Convert binary variables to logicals

## 4a step 1: Convert deltype cesarean (2) to 0 (false) and convert to logical
vipcls$deltype[vipcls$deltype == 2] <- 0
vipcls$deltype <- as.logical(vipcls$deltype)

## 4a step 2: Convert 2 (No) to 0 (false) for induclab and convert to logical
vipcls$induclab[vipcls$induclab == 2] <- 0
vipcls$induclab <- as.logical(vipcls$induclab)

## 4a step 3:  Convert 2 (No) to 0 (false) for auglab and convert to logical
vipcls$auglab[vipcls$auglab == 2] <- 0
vipcls$auglab <- as.logical(vipcls$auglab)

## 4a step 4:  Convert 2 (No) to 0 (false) for intrapih and convert to logical
vipcls$intrapih[vipcls$intrapih == 2] <- 0
vipcls$intrapih <- as.logical(vipcls$intrapih)

# Convert categorical variables w/ more than 2 levels to factors

## 4b step 1: Convert etoh 1
vipcls$etoh1 <- factor(vipcls$etoh1, levels = 1:6, labels = c("every day", "3-5/wk", "1/wk", "<1/wk", "<1/month", "never"))

## 4b step 2:  Convert etoh 2
vipcls$etoh2 <- factor(vipcls$etoh2, levels = 1:6, labels = c("every day", "3-5/wk", "1/wk", "<1/wk", "<1/month", "never"))

## 4b step 3:  Convert marstat
vipcls$marstat <- factor(vipcls$marstat, levels = 1:5, labels = c("married", "separated", "divorced", "widowed", "never married"))

## 4b step 4: Convert raceth
vipcls$raceth <- factor(vipcls$raceth, levels = 0:2, labels = c("White", "Hispanic", "Black"))

# 5. Determine the min, max, mean & the # of missing values for numeric variables, # observations, levels, and the number of missing values for binary/categorical variables
summary(vipcls)

# 6a. percentage of mothers drank alcohol exactly one time per week during their second trimester
table(vipcls$etoh2)
tableA <- table(vipcls$etoh2)
prop.table(tableA) * 100

# 6b. calculate the median
median(vipcls$grade, na.rm = TRUE)

# 6b. calculate the 95th percentile of years of education
quantile(vipcls$grade, c(.95), na.rm = TRUE)

# 6c. Calculate  mean, standard deviation, and sample sizes for mother’s age in each of the five marital groups
mean(vipcls$momage[vipcls$marstat == "married"], na.rm = TRUE)
sd(vipcls$momage[vipcls$marstat == "married"], na.rm = TRUE)
quantile(vipcls$momage[vipcls$marstat == "married"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat == "separated"], na.rm = TRUE)
sd(vipcls$momage[vipcls$marstat == "separated"], na.rm = TRUE)
quantile(vipcls$momage[vipcls$marstat == "separated"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat == "divorced"], na.rm = TRUE)
sd(vipcls$momage[vipcls$marstat == "divorced"], na.rm = TRUE)
quantile(vipcls$momage[vipcls$marstat == "divorced"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat == "widowed"], na.rm = TRUE)
sd(vipcls$momage[vipcls$marstat == "widowed"], na.rm = TRUE)
quantile(vipcls$momage[vipcls$marstat == "widowed"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat == "never married"], na.rm = TRUE)
sd(vipcls$momage[vipcls$marstat == "never married"], na.rm = TRUE)
quantile(vipcls$momage[vipcls$marstat == "never married"], c(1), na.rm = TRUE)

# BONUS: patient IDs of the 5 subjects whose children had the smallest birthweights
## Sort
ordered_data <- vipcls[order(vipcls$bw), ]

## Find the 5 patient ids on the top
ptid_lbw <- ordered_data$patid[0:5]
print(ptid_lbw)
