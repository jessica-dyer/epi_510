#Classwork 10.14.22
#--------------------
#setwd
wd <- "~/Repositories/epi_510/Classwork/10.14.22/data"
setwd(wd)

#read in the data files
decade1970 <- read.csv("gbdChildMortality_1970s.csv")
decade1980 <- read.csv("gbdChildMortality_1980s.csv")
decade1990 <- read.csv("gbdChildMortality_1990s.csv")
decade2000 <- read.csv("gbdChildMortality_2000s.csv")
decade2010 <- read.csv("gbdChildMortality_2010s.csv")
wbindicators <- read.csv("worldBankCountryIndicators.csv")
wbinfo <- read.csv("worldBankCountryInfo.csv")

#append decades into one dataset 
master <- rbind(decade1970, decade1980, decade1990, decade2000, decade2010)

#merge in world bank country indicators
master <- merge(master, wbindicators, by = c("iso", "year"), all = T)

#merge in wb country info
master <- merge(master, wbinfo, by = "iso", all = T)