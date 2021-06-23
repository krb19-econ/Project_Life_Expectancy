clear all
set more off
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\model_diag.smcl", replace

/*Open dataset*/
use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

/*Panel data*/
xtset id_country year


/*Test for time fixed effects*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap ghe_per undernourishment immune pollution i.year , fe
testparm i.year

//HAS COME OUT TO BE SIGNIFICANT. SHOULD KEEP TIME FIXED EFFECTS ALSO



/*MULTICOLLINEARITY*/
//Using VIF would give fallacious results; extremely high due to presence of dummies

regress life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap i.id_country
estat vif

//Rather than this, use vce matrix after fixed effects model
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap ghe_per undernourishment immune pollution, fe
estat vce, corr
//Seems ok



/*HETEROSCEDASTICITY*/
//Will look at error vs Y fitted and error^2 vs Y fitted

xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap ghe_per undernourishment immune pollution, fe
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
regress error_sq urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap
//Here also the F test is significant



/*SERIAL CORRELATION*/ 
xtserial life_exp urban_pop ghe_per  undernourishment immune pollution unemployment bottom_50per_income gni_pcap
//Indicates autocorrelation

/*PANEL CORRELATION*/
xtreg life_exp urban_pop unemployment bottom_50per_income gni_pcap ghe_per undernourishment immune pollution, fe
xtcsd, pesaran 

xtcdf urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap
//Both show existance of panel correlation



/*LINEARITY*/

log close
