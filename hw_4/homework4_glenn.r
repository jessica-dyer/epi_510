## ---------------------------
##
## Script name: EPI 510 R Assignment 4
##
## Purpose of script: Homework 4
##
## Author: Susan Glenn
##
## Date Created: 2022-10-26
##
## ---------------------------

##Load packages
library(tidyverse)
library(epiR)

##Set working directory
wd <- "~/Repositories/epi_510/hw_4/"
setwd(wd)

##Load data
vipcls <- read_rds("data/vipclsClean.rds")

##1. View data
str(vipcls)
glimpse(vipcls)

##2. Explore distribution of birth weight
##a. Produce a histogram of the distribution of birth weight. 
png("plots/histogram_birth_weights.png")
hist(vipcls$bw, main = "Histogram of birth weights", xlab = "Birth weight in grams")
dev.off()
##b. Produce a boxplot for birth weight grouped by categories of smokeFirst (use the 1/2 version).
png("plots/boxplot_birth_weight.png")
boxplot(vipcls$bw ~ vipcls$smokeFirst, 
        ylab = "Birth weight in grams", xlab = "Mother Smoked in First Trimester")
dev.off()

##c. Produce a boxplot for birth weight grouped by categories of over25 (use the 1/2 version).
png("plots/boxplot_birth_weight_over_25.png")
boxplot(vipcls$bw ~ vipcls$over25, 
        ylab = "Birth weight in grams", xlab = "Mother >25 Years Old")
dev.off()
##3. Look at relationship between smoking while pregnant and low birth weight.
##a. Produce a 2x2 table of smokeFirst and lbw.
rrSmokeLBWTable <- table(vipcls$smokeFirst, vipcls$lbw, deparse.level = 2)

##b. Use the epi.2by2 function to estimate the crude RR for the association between smoking and low birth weight. What is the RR?
rrStratSmokeLBW <- epi.2by2(dat=rrSmokeLBWTable, method="cohort.count")

##c. Use the epi.2by2 function to estimate the crude OR for the association between smoking and low birth weight. What is the OR? 
rrStratSmokeLBW <- epi.2by2(dat=rrSmokeLBWTable, method="cohort.count")

##4. Determine if maternal age is either a confounder or effect modifier.
##a. Use epi.2by2 function to estimate the RR for the association between any smoking and low birth weight, adjusted for maternal age older than 25. What are the adjusted, crude, and stratum-specific RRs, and their 95% CIs? 
rrStratSmokeLBWage <- table(vipcls$smokeFirst, vipcls$lbw, vipcls$over25, deparse.level = 2)
epi.2by2(dat = rrStratSmokeLBWage, method = "cohort.count")
