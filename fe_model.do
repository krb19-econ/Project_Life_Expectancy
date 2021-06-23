clear all
set more off 
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\fe_model.smcl", replace

use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

cd "C:\Users\Administrator\Desktop\Life_Expectancy\Regression"

/*Set panel data*/
xtset id_country year

//To export results 
ssc install outreg2

/*Model 1: Economic Variables*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap, fe vce(cluster id_country)
outreg2 using fixed_effects_model.xls, replace ctitle(Model 1)

/*Model 2: Health Factors*/
xtreg life_exp ghe_per undernourishment immune pollution, fe vce(cluster id_country)
outreg2 using fixed_effects_model.xls, append ctitle(Model 2)

/*Model 3: All Variables*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap ghe_per undernourishment immune pollution, fe vce(cluster id_country)
outreg2 using fixed_effects_model.xls, append ctitle(Model 3)

/*Model 4: Economic Variables and Time Fixed Effects*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap i.year, fe vce(cluster id_country)
outreg2 using fixed_effects_model.xls, append ctitle(Model 4)

/*Model 5: Health Factors and Time Fixed Effects*/
xtreg life_exp ghe_per undernourishment immune pollution i.year, fe vce(cluster id_country)
outreg2 using fixed_effects_model.xls, append ctitle(Model 5)

/*Model 6: All Variables and Time Fixed Effects*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap ghe_per undernourishment immune pollution i.year, fe vce(cluster id_country)
outreg2 using fixed_effects_model.xls, append ctitle(Model 6)

log close
