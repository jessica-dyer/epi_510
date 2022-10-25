## ---------------------------
##
## Script name: EPI 510 R Assignment 3
##
## Purpose of script: Homework 3
##
## Author: Susan Glenn
##
## Date Created: 2022-10-23
##
## ---------------------------

##Load packages
library(tidyverse)
library(gridExtra)

##Set working directory
wd <- "~/Repositories/epi_510/hw_3/"
setwd(wd)

##1. Loop over and append these into a single data frame
yearAppend <- NULL

for (y in seq(1970, 2010, 10)) {
  yearAppend <- rbind(yearAppend, read.csv(paste0(wd,"data/gbdChildMortality_", y, "s.csv")))
}

##2. Read in “countryCovars.csv” and merge it to the data frame yearAppend, keeping all observations from the child mortality dataset and not keeping observations only found in the countryCovars dataset.
countryCovars <- read.csv("data/countryCovars.csv")
glimpse(countryCovars)
glimpse(yearAppend)

yearAppend <- merge(yearAppend, countryCovars, by.x = c("iso", "year"), by.y = c("iso3", "year"), all.x = T, all.y = F)

##3. Make a histogram for each mortality rate variable, not typying out the variable list or copying and pasting the histogram code.
##a. a.	Use a grep command to find all of the variables that contain “MR” and assign these to an object.
mortality_columns_vector <- grep("MR", names(yearAppend))

##b. Use a for loop to loop over the variables in the object that you created in 3a. Have the loop make a histogram for each MR variable. 
for (col_num in mortality_columns_vector) {
  png(paste("histogram_", col_num, ".png", sep = ""),
      width = 1000, height = 750)
  hist(yearAppend[,col_num], 
       main = paste("Histogram of", names(yearAppend[col_num])))
  dev.off()
}


##4. Use sapply functions to build a table of means and SDs.
##a. a.	Use an sapply function to find the mean value for all MR and Death variables (i.e. columns 5 through 12). Assign the result to an object called “means”. 
means <- sapply(yearAppend[5:12], mean, na.rm = TRUE)

##b. b.	Use an sapply function to find the SD for all MR and Death variables (i.e. columns 5 through 12). Assign the result to an object called “SDs”.
standard_deviations <- sapply(yearAppend[5:12], sd, na.rm = TRUE)

##c. c.	Use a cbind function to combine the contents of “means” and “SDs” into a single table. 
meanSD <- data.frame(cbind(means,standard_deviations))
names(meanSD) <- c("Mean", "SD")
grid.table(meanSD)

##5. Practice using tapply to summarize a variable by levels of another variable.
##a. Use the tapply function to find the mean value of neoMR for each year.
tapply(yearAppend$neoMR, yearAppend$year, mean, na.rm = TRUE)

##b. BONUS: Nest a tapply function inside of an sapply function to make a table that gives the mean value for each MR and Death variable in each year.  
#meanbyyear <- data.frame(cbind(sapply(yearAppend[5:12], mean, na.rm = TRUE), tapply(yearAppend[5:12], yearAppend$year.x, mean, na.rm = TRUE)))
columns <- names(yearAppend[5:12])
means_by_year <- 
  yearAppend %>%
  group_by(year) %>%
  summarise_at(vars(columns), mean)



