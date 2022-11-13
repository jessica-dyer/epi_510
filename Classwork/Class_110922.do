set more off

cd "/Users/susanglenn/Repositories/epi_510/Classwork/data/"
import delimited "worldBankCountryIndicators.csv", ///
clear varnames(1) case(preserve)

drop hExp* 
drop oop*
keep if year >=2000 & year <= 2010

# Attach labels to variables 
label variable pop "Population, total"
label variable pop0_14 "Population ages 0-14 (% of total)"
label variable pop15_64 "Population ages 65+ (% of total)"
label variable pop65 "Population ages 15-64 (% of total)"
label variable popFemale "Population, female (% of total)"
