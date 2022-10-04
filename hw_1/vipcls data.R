## ---------------------------
## Script name: Epi 510 HW 1
##
## Purpose of script: Homework 1
##
## Author: Susan Glenn
##
## Date Created: 2022-10-03
##
## ---------------------------
##
## Notes: I'm adding a note!
##   
##
## ---------------------------

## Install Packages
library(tidyverse)

## Create a data frame by reading data from "vipcls.csv"
vipcls <- read.csv("vipcls.csv")

## Change WD to Epi 510
wd = "~/Repositories/epi_510/hw_1"
setwd(wd)

## View dataset: 
View(vipcls)

## Type of data: 
class(vipcls)

## Names of fields: 
names(vipcls)

## Dimensions of data: 
dim(vipcls)

## Structure of vipcls
## Enter code here

## Summary of data: 
summary(vipcls)

## Data Cleaning

#Set missing data to NA
vipcls[vipcls==-1] <- NA

#Set mother’s age (momage) of ≤15 to missing 
vipcls$momage[vipcls$momage<=15] <- NA

#Set gestational age (delges) above 52 to missing 
vipcls$delges[vipcls$delges>52] <- NA

#Set birth weight of babies (bw) below 300 to missing 
vipcls$bw[vipcls$bw<300] <- NA

#Set birth weight of babies (bw) 6000 and above to missing 
vipcls$bw[vipcls$bw>=6000] <- NA

#Convert binary variables to logicals

#Step 1: Convert deltype cesarean (2) to 0 (false) and convert to logical
# Are we considering deltype as boolean? If yes, this code works correctly.
# Here I've assigned the value to a new variable instead of overwriting the
# original. 
vipcls$deltype_bool <- vipcls$deltype
vipcls$deltype_bool[vipcls$deltype_bool==2] <- 0
vipcls$deltype_bool <- as.logical(vipcls$deltype_bool)

#Step 2: Convert 2 (No) to 0 (false) for induclab and convert to logical
vipcls$induclab[vipcls$induclab==2] <- 0
vipcls$induclab <- as.logical(vipcls$induclab)

#Step 3: Convert 2 (No) to 0 (false) for auglab and convert to logical
vipcls$auglab[vipcls$auglab==2] <- 0
vipcls$auglab <- as.logical(vipcls$auglab)

#Step 4: Convert 2 (No) to 0 (false) for intrapih and convert to logical
vipcls$intrapih[vipcls$intrapih==2] <- 0
vipcls$intrapih <- as.logical(vipcls$intrapih)
  
#Convert categorical variables w/ more than 2 levels to factors

#Step 1: Convert etoh 1
vipcls$etoh1  <-  factor(vipcls$etoh1, levels = 1:6, labels=c("every day", "3-5/wk", "1/wk","<1/wk", "<1/month", 	"never"))	

#Step 2: Convert etoh 2
vipcls$etoh2  <-  factor(vipcls$etoh2, levels = 1:6, labels=c("every day", "3-5/wk", "1/wk","<1/wk", "<1/month", 	"never"))	

#Step 3: Convert marstat
vipcls$marstat  <-  factor(vipcls$marstat, levels = 1:5, labels=c("married", "separated", "divorced","widowed", "never married"))	

#Step 4: Convert raceth
vipcls$raceth  <-  factor(vipcls$raceth, levels = 0:2, labels=c("White", "Hispanic", "Black"))	

# deltype as categorical
vipcls$deltype_cat <- factor(vipcls$deltype, levels = 1:2, labels=c("Cesarean", "Vaginal"))
table(vipcls$deltype_cat)

#determine the minimum, maximum, mean and the number of missing values for the numeric variables & levels, # observations and the number of missing values for binary/categorical variables
summary(vipcls)

#percentage of mothers drank alcohol exactly one time per week during their second trimester
table(vipcls$etoh2)
tableA <- table(vipcls$etoh2)
prop.table(tableA)*100

#calculate the median
median(vipcls$grade, na.rm = TRUE)

#calculate the 95th percentile of years of education
quantile(vipcls$grade, c(0, .1, .5, .75, .95, 1), na.rm = TRUE)

#Calculate  mean, standard deviation, and sample sizes for mother’s age in each of the five marital groups
mean(vipcls$momage[vipcls$marstat=="married"], na.rm = TRUE) 
sd(vipcls$momage[vipcls$marstat=="married"], na.rm = TRUE) 
quantile(vipcls$momage[vipcls$marstat=="married"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat=="separated"], na.rm = TRUE) 
sd(vipcls$momage[vipcls$marstat=="separated"], na.rm = TRUE) 
quantile(vipcls$momage[vipcls$marstat=="separated"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat=="divorced"], na.rm = TRUE) 
sd(vipcls$momage[vipcls$marstat=="divorced"], na.rm = TRUE) 
quantile(vipcls$momage[vipcls$marstat=="divorced"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat=="widowed"], na.rm = TRUE) 
sd(vipcls$momage[vipcls$marstat=="widowed"], na.rm = TRUE) 
quantile(vipcls$momage[vipcls$marstat=="widowed"], c(1), na.rm = TRUE)
mean(vipcls$momage[vipcls$marstat=="never married"], na.rm = TRUE) 
sd(vipcls$momage[vipcls$marstat=="never married"], na.rm = TRUE) 
quantile(vipcls$momage[vipcls$marstat=="never married"], c(1), na.rm = TRUE)

# patient IDs of the 5 subjects whose children had the smallest birthweights
# You need to actually find just the 5 participants whose children had the smallest
# birthweights.Currently you're just sorting by bw.

# Something like this:
# Sort
ordered_data <- vipcls[order(vipcls$bw), ]

# Find the 5 patient ids on the top
ptid_lbw <- ordered_data$patid[0:5]
print(ptid_lbw)


