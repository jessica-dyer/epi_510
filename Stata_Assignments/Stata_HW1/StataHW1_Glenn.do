/*
Author: Susan Glenn
Date created: 13 November 2022
Last modified: 14 November 2022

Purpose: Epi 510 Stata Homework 1
*/

*** Set up session *** 
// 1a. Set working directory
clear all
set more off
cd "/Users/susanglenn/Repositories/epi_510/Stata_Assignments/Stata_HW1"

// 1b. Import data
use data/vipcls.dta

*** Review data ***
// 2a. Describe dataset
describe

// 2b. Check size of dataset
memory

// 2c. Compress dataset
compress

// 2d. Check size of dataset after compressing 
memory

// 2e. Describe dataset after compressing
describe

*** Examine the data ***
// 3a. Visually inspect data
browse

// 3b. Determine number of missing observations for each variable and range of 
//     values using misstable command 
misstable summarize, all

*** Data cleaning ***
// 4a. Set -1 values to missing for each variable 
replace enrmo=. if enrmo==-1
replace enrdy = . if enrdy == -1
replace enryr = . if enryr == -1
replace patid = . if patid == -1
replace delmo = . if delmo == -1
replace deldy = . if deldy == -1
replace delyr = . if delyr == -1
replace momage = . if momage == -1
replace raceth = . if raceth == -1
replace grade = . if grade == -1
replace marstat = . if marstat == -1
replace cigs1 = . if cigs1 == -1
replace cigs2 = . if cigs2 == -1
replace etoh1 = . if etoh1 == -1
replace etoh2 = . if etoh2 == -1
replace partyr = . if partyr == -1
replace pregnum = . if pregnum == -1
replace delges = . if delges == -1
replace bw = . if bw == -1
replace deltype = . if deltype == -1
replace induclab = . if induclab == -1
replace auglab = . if auglab == -1
replace intrapih = . if intrapih == -1

// 4b. Set mom age of less than 16 to missing
replace momage = . if momage <16

// 4c. Set gestational age (delges) above 52 to missing
replace delges = . if delges >52 & !missing(delges)

// 4d. Set birth weight <300 and >6000 to missing
replace bw = . if bw <300
replace bw = . if bw >6000

// Use Stata commands tabulate, summarize, and tabstat to answer:
// 5a. Percentage of mothers who drank alcohol exactly one time per week during 
//     their second trimester, excluding those with missing values
tabulate(etoh2) if !missing(etoh2)

// 5b. Median and 95th percentile of years of education
tabstat grade, stat(median p95)

// 5c. Mean, sd, and sample sizes for mother's age in each marital group
tabstat momage, by(marstat) stat(n mean sd)

*** Bonus Question ***
// Patient IDs of the 5 subjects whose children had the smallest birthweights.
gsort bw
browse




