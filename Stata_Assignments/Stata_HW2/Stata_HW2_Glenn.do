/*
Author: Susan Glenn
Date created: 18 November 2022
Last modified: 21 November 2022

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
replace bw = . if bw <3002
replace bw = . if bw >6000

// 1b. Use misstable summarize, all to produce output to check for appropriate values
misstable summarize, all

*** 2. Define new categorical variables based upon existing variables ***
// 2a. momage (<19, 20-29, 30+) -> momageCat (1, 2, 3) 
generate momageCat = 1 if momage <= 19
replace momageCat = 2 if inrange(momage, 20, 29) 
replace momageCat = 3 if momage >=30
tab momage momageCat

// 2b. grade (<12, 13+) -> college (0, 1)
generate college = 0 if grade <= 12
replace college = 1 if grade >=13
tab grade college

// 2c. marstat (1, 2-4, 5) -> marCat (1, 2, 3)
generate marCat = 1 if marstat == 1
replace marCat = 2 if inrange(marstat, 2, 4)
replace marCat = 3 if marstat >=5
tab marstat marCat

// 2d. partyr (<1, 2+) -> monog (1, 0) 
generate monog = 1 if partyr <= 1
replace monog = 0 if partyr >=2
tab partyr monog

// 2e. pregnum (1 vs 2+) ->	multipar (0, 1)
generate multipar = 0 if pregnum == 1 
replace multipar = 1 if pregnum >=2
tab pregnum multipar

// 2f. delges (<37, 37-42, 43+) -> delgesCat (1, 2, 3)
generate delgesCat = 1 if delges <37
replace delgesCat = 2 if inrange(delges, 37, 42)
replace delgesCat = 3 if delges >=43
tab delges delgesCat

// 2g. bw (<1500, 1500-2499, 2500-3999, 4000+) -> bwCat (1, 2, 3, 4). 
generate bwCat = 1 if bw <1500
replace bwCat = 2 if inrange(bw, 1500, 2499)
replace bwCat = 3 if inrange(bw, 2500, 3999)
replace bwCat = 4 if bw >4000

// 2h. create a new variable for Study Clinic (clinic)
generate clinic = 1 if inrange(patid, 1000000, 1999999)
replace clinic = 3 if inrange(patid, 3000000, 3999999)
replace clinic = 5 if inrange(patid, 5000000, 5999999)
replace clinic = 6 if inrange(patid, 6000000, 6999999)
replace clinic = 7 if inrange(patid, 7000000, 7999999)
replace clinic = 8 if inrange(patid, 8000000, 8999999)
replace clinic = 9 if inrange(patid, 9000000, 9999999)
browse clinic

*** 3. Define 2 new variables categorizing smoking and alcohol use in 1st and 2nd trimester. ***
// 3a. Create a new variable, called smoke, for smoking during pregnancy with three categories: // (1) never smoked, (2) 1st trimester only, and (3) 2nd trimester with or without smoking in
// the 1st trimester. 
generate smoke = 1 if cigs1 == 0 & cigs2 == 0
replace smoke = 2 if cigs1 >= 1 & cigs2 == 0
replace smoke = 3 if cigs2 >= 1

//b. Create a new variable, called drink, for alcohol use during pregnancy with three
// categories: (1) non-drinker, (2) use in 1st trimester only, and (3) use in 2nd trimester 
// with or without use in the 1st trimester. 
generate drink = 1 if etoh1 == 6 & etoh2 == 6
replace drink = 2 if etoh1 <6 & etoh2 == 6
replace drink = 3 if etoh2 <6

*** 4. Date variables ***
// 4a. Create a date variable containing the enrollment date.
generate enrDate = mdy(enrmo, enrdy, enryr)
view enrDate

// 4b. Create a date variable containing the delivery date. 
generate delDate = mdy(delmo, deldy, delyr)

// 4c. Format these two new date variables in %td format. 
format %td enrDate
format %td delDate

// 4d. Create a new variable containing the number of days between enrollment and delivery. 
generate daysEnrToDel = delDate-enrDate
browse daysEnrToDel

// 4e. Determine if there are any delivery dates which precede enrollment. If so, at which clinic was the subject who had date problems enrolled?
sort daysEnrToDel
browse

// 4f. Set any implausible number of days between enrollment and delivery to missing in your permanent Stata dataset. 
replace daysEnrToDel = . if daysEnrToDel <0

*** 5. Add labels to produce a neat dataset ***
// a. Label all variables in the dataset (variable labels) 
label variable patid "Patient ID"
label variable delmo "Delivery month"
label variable deldy "Delivery day"
label variable delyr "Delivery year"
label variable enrmo "Enrollment month"
label variable enrdy "Enrollment day"
label variable enryr "Enrollment year"
label variable momage "Mother's age"
label variable raceth "Mother's race/ethnicity"
label variable grade "Education"
label variable marstat "Mother's marital status"
label variable cigs1 "Smoking 1st trimester"
label variable cigs2 "Smoking 2nd trimester"
label variable etoh1 "Alcohol 1st trimester"
label variable etoh2 "Alcohol 2nd trimester"
label variable partyr "No. of sex partners last year"
label variable pregnum "No. of pregnancies"
label variable delges "Gestational age at delivery"
label variable bw "Birth weight"
label variable deltype "Delivery method"
label variable induclab "Induction of labor"
label variable auglab "Augmentation of labor"
label variable intrapih "Gestational hypertension"
label variable etoh1 "Alcohol 1st trimester"

// b. Define and apply value labels to all categorical variables (raceth, marstat, etoh1, etoh2, // deltype, induclab, auglab, intrapih, and all variables created in questions 2 and 3 of this // assignment). 
label variable momageCat "Mother's age categorical"
label define momageCatDef 1 "<19" 2 "20-29" 3 "30+"
label values momageCat momageCatDef
tabulate momageCat

label variable college "Mother's education categorical"
label define collegeDef 0 "no college" 1 "college"
label values college collegeDef

label variable marCat "Mother's marital status categorical"
label define marCatDef 1 "married" 2 "separated/divorced/widowed" 3 "never married"
label values marCat marCatDef

label variable monog "Monogamous"
label define monogDef 1 "<=1 sexual partner" 2 ">1 sexual partner"
label values monog monogDef

label variable multipar "Multiparity"
label define multiparDef 0 "1 pregnancy" 1 "2+ pregnancies"
label values multipar multiparDef

label variable delgesCat "Gestational age at delivery categorical"
label define delgesCatDef 1 "<37 weeks" 2 "37-42 weeks" 3 "43+ weeks"
label values delgesCat delgesCatDef

label variable bwCat "Birthweight categorical"
label define bwCatDef 1 "<1500" 2 "1500-2499" 3 "2500-3999" 4 "4000+"
label values bwCat bwCatDef

label variable clinic "Clinic"
label define clinicDef 1 "Olympia" 3 "Everett" 5 "Seattle" 6 "Bellingham" 7 "Spokane" 8 "Bellevue" 9 "Tacoma"
label values clinic clinicDef

label variable smoke "Smoking during pregnancy"
label define smokeDef 1 "never smoked" 2 "1st trimester only" 3 "2nd trimester with or without smoking in 1st tri"
label values smoke smokeDef

label variable drink "Drinking during pregnancy"
label define drinkDef 1 "non-drinker" 2 "use in 1st trimester only" 3 "use in 2nd trimester with or without use in 1st trimester"
label values drink drinkDef

*** 6.	Save this dataset as vipclsClean.dta ***
save "vipclsClean.dta", replace
