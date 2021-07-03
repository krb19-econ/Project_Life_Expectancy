clear all
set more off
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\model_diag.smcl", replace

/*Open dataset*/
use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

/*Panel data*/
xtset id_country year

/*Wouldn't be including pollution and undernourishment data*/

/*TIME FIXED EFFECTS*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune i.year , fe
testparm i.year

//HAS COME OUT TO BE SIGNIFICANT. SHOULD KEEP TIME FIXED EFFECTS ALSO



/*SERIAL CORRELATION*/ 
xtserial life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune
//Indicates autocorrelation



/*PANEL CORRELATION*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, fe
xtcsd, pesaran 

xtcdf urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune
//Both show existance of panel correlation





/*HETEROSCEDASTICITY*/
//Will look at error vs Y fitted and error^2 vs Y fitted

xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, fe
predict error, e
predict fit, xb
generate error_sq = error^2

twoway (scatter error fit)
//Doesn't show any correlation

twoway (scatter error_sq fit)
//Seems to be a horizontal line apart from a few outliers
//Possible heteroscedasticity

/*Can perform Wald Test. xttest3 in Stata; will have to install it*/
xttest3
//Clearly indicates heteroscedasticity

/*Whiite's General Test*/
regress life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune
//Here also the F test is significant

/*Hence we have presence of heteroscedasticity*/




/*MULTICOLLINEARITY*/
//Using VIF would give fallacious results; extremely high due to presence of dummies

regress life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune i.id_country
estat vif

//Rather than this, use vce matrix after fixed effects model
xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, fe vce(cluster id_country)
estat vce, corr

xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune i.year , fe vce(cluster id_country)
estat vce, corr 


log close
