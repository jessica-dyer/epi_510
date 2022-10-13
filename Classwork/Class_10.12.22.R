## ---------------------------
##
## Script name: Classwork
##
## Purpose of script: Classwork & notes
##
## Author: Susan Glenn
##
## Date Created: 2022-10-12
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------
vipcls <- read.csv("/Users/susanglenn/Repositories/epi_510/hw_2/data/vipcls.csv")
names(vipcls)
variabledel <- c(names(vipcls))
grepl("del", variabledel)
grep("del", variabledel, value = TRUE)
summary(grep("del", variabledel, value = TRUE))
summary(grep("del", variabledel))
