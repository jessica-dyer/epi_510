clear
cd /users/susanglenn/Repositories/epi_510/Stata_Assignments
use "gbdChildMortalityData.dta", clear

generate n = _n
display _n

// bysort & tabstat
sort(year)
bysort year: summarize neoMR if year >=2000
tabstat neoMR if year >=2000
tabstat neoMR if year >=2000, by(year) stat (n mean sd min p25 p50 p75 max)
bysort region: tabstat neoMR if year >=2000, by(year) stat (n mean sd min p25 p50 p75 max)

bysort country (year): gen countryIndex = _n
bysort country: gen countryN = _N
browse country* year

bysort country(year): gen firstYear = _n==1
tabulate year if firstYear==1

bysort country: egen minYear = min(year)

bysort country: egen totalu5deaths = total(under5Deaths)
bysort under5Deaths (country): gen under5deathIndex = _n
replace under5deathIndex = . if _n < 41
browse totalu5deaths* country

use "gbdChildMortality_1970s.dta", clear
append using "gbdChildMortality_1980s.dta" ///
gbdChildMortality_1990s.dta ///
gbdChildMortality_2000s.dta ///
gbdChildMortality_2010s.dta
