## ---------------------------
##
## Script name: EPI 510 R Assignment 2
##
## Purpose of script: Homework 2
##
## Author: Susan Glenn
##
## Date Created: 2022-10-11
##
## ---------------------------
##
## Notes: Having trouble on:
##        1. Lines 64-66 - I'm not sure how to skip/drop levels 2 & 4, as there aren't corresponding clinic IDs.
              ## You've done this correctly. However, there were some errors in the actual code that I fixed to make it work
              ## Properly. 
##        2. Lines 88-89 - I'm not sure how to identify the patient ID with a delivery date prior to enrollment in base r.
##        3. Would implausible delivery dates (question 4e) just be anything over a normal days from pregnancy to delivery? (line 90)
##        4. All the variables I converted to categorical variables are listed as NA now (grade, deltype, induclab, etc.). Is this ok?
##
## ---------------------------

## Set working directory
current_hw_folder <- "hw_2"
directory <- paste("~/Repositories/epi_510/", current_hw_folder, sep = '')
setwd(directory)

## 1. Get data from HW 1
vipcls <- readRDS(file = "~/Repositories/epi_510/vipcls.rds")


## 2. Define new categorical variables
## a. momage
vipcls$momageCat[vipcls$momage<=19] <- 1
vipcls$momageCat[vipcls$momage>19 & vipcls$momage<30] <- 2
vipcls$momageCat[vipcls$momage>=30] <- 3
## b. grade
vipcls$college[vipcls$grade<=12] <- 0
vipcls$college[vipcls$grade>12] <- 1
##c. marstat
vipcls$marCat[vipcls$marstat==1] <- 1
vipcls$marCat[vipcls$marstat>1 & vipcls$marstat <=4] <- 2
vipcls$marCat[vipcls$marstat >4] <- 3
##d. partyr
vipcls$monog[vipcls$partyr<=1] <- 1
vipcls$monog[vipcls$partyr>1] <- 0
##e. pregnum
vipcls$multipar[vipcls$pregnum == 1] <- 0
vipcls$multipar[vipcls$pregnum >=2] <- 1
##f.delges
vipcls$delgesCat[vipcls$delges<37] <- 1
vipcls$delgesCat[vipcls$delges>=37 & vipcls$delges<=42] <- 2
vipcls$delgesCat[vipcls$delges>42] <- 3
##g. bw
vipcls$bwCat[vipcls$bw<1500] <- 1
vipcls$bwCat[vipcls$bw>=1500 & vipcls$bw<=2499] <- 2
vipcls$bwCat[vipcls$bw>=2500 & vipcls$bw<=3999] <- 3
vipcls$bwCat[vipcls$bw>=4000] <- 4
##h. clinic
vipcls$clinic[vipcls$patid>=1000000 & vipcls$patid <=1999999] <- 1
vipcls$clinic[vipcls$patid>=3000000 & vipcls$patid <=3999999] <- 3
vipcls$clinic[vipcls$patid>=5000000 & vipcls$patid <=5999999] <- 5
vipcls$clinic[vipcls$patid>=6000000 & vipcls$patid <=6999999] <- 6
vipcls$clinic[vipcls$patid>=7000000 & vipcls$patid <=7999999] <- 7
vipcls$clinic[vipcls$patid>=8000000 & vipcls$patid <=8999999] <- 8
vipcls$clinic[vipcls$patid>=9000000 & vipcls$patid <=9999999] <- 9
vipcls$clinic <- factor(vipcls$clinic,
  levels = c(1,3,5,6:9),
  labels = c("Olympia", "Everett", "Seattle", "Bellingham", "Spokane", "Bellevue", "Tacoma"))

## 3. Create smoke and drink variables
##a. smoke
vipcls$smoke[vipcls$cigs1==0 & vipcls$cigs2==0] <- 1
vipcls$smoke[vipcls$cigs1>0 & vipcls$cigs2==0] <-2
vipcls$smoke[vipcls$cigs2>0] <- 3
##b. drink
vipcls$drink[vipcls$etoh1==0 & vipcls$etoh2==0] <- 1
vipcls$drink[vipcls$etoh1>0 & vipcls$etoh2==0] <- 2
vipcls$drink[vipcls$etoh2>0] <- 3

## 4. Date variables
##a. enrollment date
vipcls$enroll_date <- as.Date(paste(vipcls$enryr, vipcls$enrmo, vipcls$enrdy, sep = '-'))
##b. delivery date
vipcls$del_date <- paste(vipcls$delyr, vipcls$delmo, vipcls$deldy, sep='-')
head(vipcls$del_date)
vipcls$del_date[grep("-1--1--1", vipcls$del_date)] <- NA
vipcls$del_date <- as.Date(vipcls$del_date)
##c. days between enrollment and delivery
vipcls$enrollToDelDays <- difftime(vipcls$del_date, vipcls$enroll_date)
##d. Investigate which ptid has a delivery date prior to enrollment
ptid <- vipcls$patid[vipcls$enrollToDelDays < 0]
ptid <- ptid[!is.na(ptid)]
##e. Set implausible number of days between enrollment and delivery to missing
vipcls$enrollToDelDays[vipcls$enrollToDelDays < 0] <- NA  

## 5. Add labels to new categorical variables
vipcls$raceth <- factor(vipcls$raceth, 
                       levels = 0:2, 
                       labels = c("White", "Hispanic", "Black"))
vipcls$grade <- factor(vipcls$grade, 
                       levels = c('<=12', '>12'), 
                       labels = c("no college", "college"))
vipcls$marstat <- factor(vipcls$marstat,
                       levels = 1:5,
                       labels = c("married", "separated", "divorced", "widowed", "never married"))
vipcls$etoh1 <- factor(vipcls$etoh1,
                       levels = 1:6,
                       labels = c("every day", "3-5/wk", "one/wk", "<one/wk", "<one/month", "never"))
vipcls$etoh2 <- factor(vipcls$etoh2,
                       levels = 1:6,
                       labels = c("every day", "3-5/wk", "one/wk", "<one/wk", "<one/month", "never"))
vipcls$deltype <- factor(vipcls$deltype,
                       levels = 1:2,
                       labels = c("vaginal", "cesarean"))
vipcls$induclab <- factor(vipcls$induclab,
                       levels = 1:2,
                       labels = c("yes", "no"))
vipcls$induclab <- factor(vipcls$induclab,
                       levels = 1:2,
                       labels = c("yes", "no"))
vipcls$auglab <- factor(vipcls$auglab,
                       levels = 1:2,
                       labels = c("yes", "no"))
vipcls$intrapih <- factor(vipcls$intrapih,
                       levels = 1:2,
                       labels = c("yes", "no"))
vipcls$momageCat <- factor(vipcls$momageCat,
                       levels = 1:3,
                       labels = c("<19", "20-29", "30+"))
vipcls$college <- factor(vipcls$momageCat,
                       levels = 0:1,
                       labels = c("no college", "college"))
vipcls$marCat <- factor(vipcls$marCat,
                       levels = 1:3,
                       labels = c("married", "separated/divorced/widowed", "never married"))
vipcls$monog <- factor(vipcls$monog,
                       levels = 0:1,
                       labels = c("not monogamous", "monogamous"))
vipcls$multipar <- factor(vipcls$multipar,
                       levels = 0:1,
                       labels = c("primiparity", "multiparity"))
vipcls$delgesCat <- factor(vipcls$delgesCat,
                       levels = 1:3,
                       labels = c("<37 weeks", "37-42 weeks", "43+ weeks"))
vipcls$bwCat <- factor(vipcls$bwCat,
                       levels = 1:4,
                       labels = c("<1500 grams", "1500-2499 grams", "2500-3999 grams", "4000+ grams"))
vipcls$smoke <- factor(vipcls$smoke,
                       levels = 1:3,
                       labels = c("never", "1st trimester only", "2nd tri w/ or w/o 1st tri"))
vipcls$drink <- factor(vipcls$drink,
                       levels = 1:3,
                       labels = c("never", "1st trimester only", "2nd tri w/ or w/o 1st tri"))
