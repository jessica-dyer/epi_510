# Store the working directory as an object
directory <- paste("~/Repositories/epi_510/hw_2", sep = '')
setwd(directory)

# Read in vipcls
vipcls <- readRDS(file = "~/Repositories/epi_510/vipcls.rds")

# Set all -1 values to missing
vipcls[vipcls==-1] <- NA

# Set mother's age (momage) of 15 to missing
vipcls$momage[vipcls$momage==15] <- NA

# Set gestational age (delges) above 52 to missing
vipcls$delges[vipcls$delges>52] <- NA

# Set birth weight of babies (bw) below 300 or 6000 and above to missing
vipcls$bw[vipcls$bw<300 | vipcls$bw>=6000] <- NA

# Boxplot 
boxplot(vipcls$momage ~ vipcls$pregnum, 
        ylab = "Age (years)", xlab = "Pregnancy Number")

# Install epiR package
install.packages("epiR")
library("epiR")

# Create prematurity variable
vipcls$premature <- NULL
vipcls$premature <- factor(vipcls$delges>=37, levels = c(F,T), labels = c("Yes", "No"))

# Create alcohol variable
vipcls$etoh1perMo <- (as.numeric(vipcls$etoh1)>=5 & as.numeric(vipcls$etoh2)>=5) + 1
vipcls$etoh1perMo <- factor(vipcls$etoh1perMo, levels = 1:2, labels = c("Yes", "No"))

# Create smoking variable
vipcls$smokeFirst <- factor((vipcls$cigs1==0)+1, levels = 1:2, labels = c("Yes", "No"))

table(vipcls$cigs1, vipcls$smokeFirst, useNA = "always")

# 2x2 Table - looking at association between smoking in 1st tri and premature birth 
(rrTab <- table(vipcls$smokeFirst, vipcls$premature, deparse.level = 2))

# Feed table through epiR to do analysis
(rrStrat <- epi.2by2(dat = rrTab, method = "cohort.count"))

# Does alcohol consumption confound the relationship between smoking and premature birth?
(rrTabStrat <- table(vipcls$smokeFirst, vipcls$premature, vipcls$etoh1perMo,deparse.level = 2))
(rrStrat <- epi.2by2(dat=rrTabStrat, method="cohort.count"))

