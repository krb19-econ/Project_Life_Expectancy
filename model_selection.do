clear all
set more off 
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\model_selection.smcl", replace

use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

/*Set panels*/
xtset id_country year

/*Would not be using ghe per capita as mentioned earlier*/
/*Will first do a fixed effects regression*/

//By using regress
regress life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap i.id_country

//F test comes out to be significant.  Rejects null hypothesis that all coefficients are equal to zero

//By rusing xtreg
xtreg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap, fe

//Here the F test at bottom shows F test for the dummy variables for each country are not together equal to zero. 
//Also high correlation between u_i and Xi, so can't put u_i with error terms. Still will check RE model once

/*Both methods have dropped 7 countries*/

//Can also do with areg
areg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap, absorb(id_country)
//Here also F test comes out ti be the same. Rejects null hypothesis that dummies equal to zero
//The F test given above of (9,243) is for the 9 variables, not the dummies

/*Now doing a random effects model*/
//Random effects assume that the entity’s error term is not correlated with the predictors. We have seen that it is not true. Stilll will form a RE model once
xtreg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap, re
xttest0 //Does a BP LM test to test for random effects. Even this has come out to be significant.

//Will now do a Hausmann Test

xtreg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap, fe
estimates store fixed
xtreg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni_pcap, re
estimates store random
hausman fixed random

/*Hausman test has a note. Coefficients of per capita variables are very low as comparted to the others. Need to change their units.*/
//Note: Doing ths just to get to correct hausman test. In the final model, can keep in the original form.

generate gni10000 = gni_pcap/10000

xtreg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni10000 , fe
estimates store fixed
xtreg life_exp urban_pop ghe_per undernourishment immune pollution unemployment bottom_50per_income gni10000 , re
estimates store random
hausman fixed random
//Again get an error. Can use sigmamore option 
hausman fixed random , sigmamore

/*Get a significant result. Hence would be opting for fixed effects model*/

log close

