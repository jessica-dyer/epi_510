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
library(ggplot2)

# 8b. Read in the clean rds version 
cleanBRFSSdata <- readRDS(file = "brfss2017Clean.rds")

# 8c. Apply the summary function to the full dataset 
summary(cleanBRFSSdata)

# Missingness analysis
png("data/missingness.png")
vis_miss(cleanBRFSSdata, warn_large_data = FALSE)
dev.off()

# 8d. Create histograms for the continuous poor physical health day variable, 
# and for the age group variable. 
hist(cleanBRFSSdata$ageBy5, xlab = "Age Group", main = "Distribution of Age")
hist(cleanBRFSSdata$daysIll, xlab = "Days Ill", main = "Distribution of Days Ill")

# 8e.i. Use either dplyr functions or tapply to create a new data.frame that 
# contains the mean of the poor physical health variable (continuous version) 
# by age group.
meanHealthByAge <- tapply(cleanBRFSSdata$daysIll, cleanBRFSSdata$ageBy5, mean, na.rm = TRUE)
dfHealthbyAge <- data.frame(meanHealthByAge, levels(cleanBRFSSdata$ageBy5Factor)) %>% 
`colnames<-`(c('MeanDaysIll', 'AgeGroup'))

# 8e.ii. Use ggplot to create a connected scatter plot (i.e. overlay a geom_point 
# and geom_line) to visualize the age pattern of the mean variable.
meanHealthByAge %>% ggplot(aes(x = ageBy5, y = Mean)) +
  geom_point() + geom_line()

dfHealthbyAge %>% ggplot(aes(x=AgeGroup, y=MeanDaysIll)) + geom_point() + 
  geom_line(aes(group=1)) +
  labs(title = 'Average Days of Poor Health by Age Group', 
       x = 'Age Group', y = 'Days of Poor Health')

# 9a. Use the epi.2by2 function with the cohort.count method to estimate the 
# crude RR to quantify the strength of the association between age 65 years older 
# and 15+ days of poor physical health. Give the RR with 95% confidence interval 
# (CI), and p-value. 
library(epiR)

cleanBRFSSdata$age65Binary[cleanBRFSSdata$age65Cat == 1] <- 1
cleanBRFSSdata$age65Binary[cleanBRFSSdata$age65Cat == 0] <- 2

cleanBRFSSdata$daysIllBinary[cleanBRFSSdata$daysIllCat == 1] <- 1
cleanBRFSSdata$daysIllBinary[cleanBRFSSdata$daysIllCat == 0] <- 2

table(cleanBRFSSdata$age65Binary)
table(cleanBRFSSdata$daysIllBinary)

(AgeAndHealthStrat <- table(cleanBRFSSdata$age65Binary, cleanBRFSSdata$daysIllBinary, 
                            deparse.level = 2))
(rrAgeAndHealth <- epi.2by2(dat=AgeAndHealthStrat, method="cohort.count")) 

#9b.i. Use the epi.2by2 function with the cohort.count method to estimate the sex 
# adjusted (and stratified) RRs to quantify the strength of the association between 
# age 65 years older and 15+ days of poor physical health.
(AgeHealthSexStrat <- table(cleanBRFSSdata$age65Binary, cleanBRFSSdata$daysIllBinary, 
                            cleanBRFSSdata$sexFactor, deparse.level = 2))
  
(rrAgeHealthSexStrat <- epi.2by2(dat=AgeHealthSexStrat, method="cohort.count"))

(crude <- rrAgeHealthSexStrat$massoc.detail$RR.crude.wald[1])
(adj <- rrAgeHealthSexStrat$massoc.detail$RR.mh.wald[1])
100 * (adj - crude) / crude

#9b.ii. Make a table with the crude and adjusted RRs, including 95% Cis and p-values. 
RRTable <- data.frame(rbind(rrAgeHealthSexStrat$massoc.detail$RR.crude.wald, 
                            rrAgeHealthSexStrat$massoc.detail$RR.mh.wald))

view(RRTable)

##10a. Use the svydesign function to define the survey design so R understands 
# how to weigh the data (refer to the class slides on this). Be sure to configure 
# options to allow for having a single observation per stratum (a “lonely psu”). 
# We now have a clean data set and have created our survey design, so we’re ready 
# to start our analysis. 
install.packages("survey")
library("survey")
options(survey.lonely.psu = "adjust")
design <- svydesign(data = cleanBRFSSdata, id = ~primSampleUnit, strata = 
                      ~stratVariable, weight = ~phoneData, nest = TRUE)

#b. Using svytable, create one-way frequency tables for the age group, age 65+, 
#   sex, 15+ poor physical health days per month.
ageGroupTab <- svytable(~ageBy5Factor, design)
age65Tab <- svytable(~age65Factor, design)
sexTab <- svytable(~sexFactor, design)
daysIllTab <- svytable(~daysIllFactor, design)

#c. Combine your svytable commands from part b with prop.table and cbind to 
#   create frequency tables that include counts and proportions for the same 
#   variables that you tabulated in part b. 
cbind(ageGroupTab, prop.table(ageGroupTab))
cbind(age65Tab, prop.table(age65Tab))
cbind(sexTab, prop.table(sexTab))
cbind(daysIllTab, prop.table(daysIllTab))

#d. Using svytable, create a 2x2 table of 15+ days of poor physical health x age 
#   65+. Have age category be the rows, and health day category be the columns. What 
#   proportion of people had 15+ days of poor physical health per month in each of 
#   the two age categories?
age65DaysIll<- svytable(~age65Factor + daysIllFactor, design)
prop.table(age65DaysIll, margin = 1)

#e. Use svymean to estimate the mean number of days per month in poor physical
#   health. What is the mean and its standard error? 
svymean(~daysIll, design, na.rm = TRUE)

#f. Use svytotal to calculate the total number of days spent in poor physical 
#   health in 2017. What is the total number of days spent in poor physical health 
#   and the standard error of that total? 
svytotal(~daysIll, design, na.rm = TRUE)