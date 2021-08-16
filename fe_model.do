clear all
set more off 
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\fe_model.smcl", replace

use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

cd "C:\Users\Administrator\Desktop\Life_Expectancy\Regression New"

/*Set panel data*/
xtset id_country year

//To export results 
//ssc install outreg2


foreach var in life_exp ma_life_exp fe_life_exp mortality_rate	{

/*Model 1: All Variables. No Fixed Effects*/
regress `var' urban_pop gni10000 unemployment ghe_per, vce(cluster id_country)
outreg2 using `var'.xls, replace ctitle(Model 1)

/*Model 2: Country Fixed Effects*/
xtreg `var' urban_pop gni10000 unemployment ghe_per, fe vce(cluster id_country)
outreg2 using `var'.xls, append ctitle(Model 2)

/*Model 3: Country and Time Fixed Effects*/
xtreg `var' urban_pop gni10000 unemployment ghe_per i.year, fe vce(cluster id_country)
outreg2 using `var'.xls, append ctitle(Model 3)

/*Model 4: Including Interaction Effect*/
xtreg `var' urban_pop gni10000 unemployment ghe_per c.gni10000#c.ghe_per i.year, fe vce(cluster id_country)
outreg2 using `var'.xls, append ctitle(Model 4)
}

log close
