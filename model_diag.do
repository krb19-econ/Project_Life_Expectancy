clear all
set more off
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\model_diag.smcl", replace

/*Open dataset*/
use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

/*Panel data*/
xtset id_country year


/*LIFE EXPECTANCY*/

foreach var in life_exp ma_life_exp fe_life_exp mortality_rate	{
xtreg `var' urban_pop gni10000 unemployment ghe_per , fe

/*TIME FIXED EFFECTS*/
xtreg `var' urban_pop gni10000 unemployment ghe_per i.year , fe 
testparm i.year



/*SERIAL CORRELATION*/ 
xtserial `var' urban_pop gni10000 unemployment ghe_per 



/*PANEL CORRELATION*/
xtreg `var' urban_pop gni10000 unemployment ghe_per , fe
xtcsd, pesaran 

xtcdf urban_pop gni10000 unemployment ghe_per 



/*HETEROSCEDASTICITY*/
//Will look at error vs Y fitted and error^2 vs Y fitted

xtreg `var' urban_pop gni10000 unemployment ghe_per , fe
predict error_`var', e
predict fit_`var', xb
generate error_sq_`var' = error_`var'^2

twoway (scatter error_`var' fit_`var')

twoway (scatter error_sq_`var' fit_`var')

/*Can perform Wald Test. xttest3 in Stata; will have to install it*/
xttest3

/*Whiite's General Test*/ 
regress error_sq_`var' urban_pop gni10000 unemployment ghe_per 





/*MULTICOLLINEARITY*/
//Using VIF would give fallacious results; extremely high due to presence of dummies

regress `var' urban_pop gni10000 unemployment ghe_per i.id_country
estat vif

/*Looking at correlation*/
pwcorr urban_pop gni10000 unemployment ghe_per 

xtreg `var' urban_pop gni10000 unemployment ghe_per , fe
estat vce, correlation

}


log close
