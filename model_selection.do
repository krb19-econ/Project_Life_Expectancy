clear all
set more off 
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\model_selection.smcl", replace

use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

/*Set panels*/
xtset id_country year

/*Not using pollution and undernourishment*/
/*Will first do a fixed effects regression*/

//By using regress
regress life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune i.id_country

//F test comes out to be significant.  Rejects null hypothesis that all coefficients are equal to zero

//By using xtreg
xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, fe

//Here the F test at bottom shows F test for the dummy variables for each country are not together equal to zero. 
//Also high correlation between u_i and Xi, so can't put u_i with error terms. Still will check RE model once

//Can also do with areg
areg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, absorb(id_country)
//Here also F test comes out ti be the same. Rejects null hypothesis that dummies equal to zero
//The F test given above of (7,337) is for the 7 variables, not the dummies


/*Now doing a random effects model*/
//Random effects assume that the entity’s error term is not correlated with the predictors. We have seen that it is not true. Stilll will form a RE model once
xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, re
xttest0 //Does a BP LM test to test for random effects. Even this has come out to be significant.


//Will now do a Hausmann Test

xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, fe
estimates store fixed
xtreg life_exp urban_pop unemployment bottom_50per_income gni10000 ghe10000 ghe_per immune, re
estimates store random
hausman fixed random

//Have a issue mentioned at the end. Can use sigmamore option. Not positive definite 
hausman fixed random , sigmamore

/*Get a significant result. Hence would be opting for fixed effects model*/

log close

