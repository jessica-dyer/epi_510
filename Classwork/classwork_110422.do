cd "/Users/susanglenn/Repositories/epi_510/Classwork/"

use "data/gbdChildMortalityData.dta", clear
compress

browse

describe

codebook

. misstable summarize, all

browse country year

summarize neoMR - under5Deaths

summarize neoMR - under5Deaths, detail

tabulate gbdRegion

tabulate region income

Tabulate one income region

tabstat neoMR, by (income) stat



use "data/worldBankCountryIndicators.dta", clear
compress

describe

browse

codebook

generate GDP2005Constant = gdp2005/pop
generate GDPCurrentConstant = gdpCurrent/pop

generate schoolenrcomp = 0 if enrollAll<99 & enrollAll!=.
replace schoolenrcomp = 1 if enrollAll>=99 & enrollAll!=.
replace schoolenrcomp = . if enrollAll==.

tabstat enrollAll, by(schoolenrcomp) stat(min max)


