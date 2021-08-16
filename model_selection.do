clear all
set more off 
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\model_selection.smcl", replace

use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

/*Set panels*/
xtset id_country year


/*Will first do a fixed effects regression*/
foreach var in life_exp ma_life_exp fe_life_exp mortality_rate	{
//By using regress
regress `var' urban_pop unemployment gni10000 ghe_per i.id_country


//By using xtreg
xtreg `var' urban_pop gni10000 unemployment ghe_per  , fe

/*Now doing a random effects model*/
xtreg `var' urban_pop gni10000 unemployment ghe_per , re
xttest0 


/*Will now do a Hausmann Test*/
xtreg `var' urban_pop gni10000 unemployment ghe_per , fe
estimates store fixed
xtreg `var' urban_pop gni10000 unemployment ghe_per , re
estimates store random
hausman fixed random


/*However, have found evidence of heteroscedasticity. Hence, will have to use robust Hausmann*/


xtreg `var' urban_pop gni10000 unemployment ghe_per , re vce(cluster id_country)
xtoverid


}

log close

