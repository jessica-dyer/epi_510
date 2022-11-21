/*
Author: Susan Glenn
Date created: 18 November 2022
Last modified: 

Purpose: Epi 510 Stata Homework 2
*/

*** 1. Data management *** 
// 1a. Start with data management code from previous assignment 
// Set working directory
clear all
set more off
cd "/Users/susanglenn/Repositories/epi_510/Stata_Assignments/Stata_HW1"

// Import data
use data/vipcls.dta

// Compress dataset
compress

// Set -1 values to missing for each variable 
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

// Set mom age of less than 16 to missing
replace momage = . if momage <16

// Set gestational age (delges) above 52 to missing
replace delges = . if delges >52 & !missing(delges)

// Set birth weight <300 and >6000 to missing
replace bw = . if bw <300
replace bw = . if bw >6000

// 1b. Use misstable summarize, all to produce output to check for appropriate values
misstable summarize, all

*** 2. Define new categorical variables based upon existing variables ***
// 2a. momage (<19, 20-29, 30+) -> momageCat (1, 2, 3) 


// 2b. grade (<12, 13+) -> college (0, 1)


// 2c. marstat (1, 2-4, 5) -> marCat (1, 2, 3)


// 2d. partyr (<1, 2+) -> monog (1, 0) 


// 2e. pregnum (1 vs 2+) ->	multipar (0, 1)


// 2f. delges (<37, 37-42, 43+) -> delgesCat (1, 2, 3)


// 2g. bw (<1500, 1500-2499, 2500-3999, 4000+) -> bwCat (1, 2, 3, 4). 


// 2h. create a new variable for Study Clinic (clinic)
