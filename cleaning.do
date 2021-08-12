clear all
set more off
version 13.1

/*Begin log*/
log using "C:\Users\Administrator\Desktop\Life_Expectancy\cleaning.smcl", replace

/*Import dataset*/
import excel "C:\Users\Administrator\Desktop\Life_Expectancy\data_v1.xls", sheet("Sheet1") firstrow

describe //Can see that value labels are not indicated properly

/*Also 2 variables in per capita terms very low. Change magnitude*/
generate gni10000 = gni_pcap/10000


/*Need to correct variable labels*/
label variable country_name "Name of the country"
label variable year "Year"
label variable life_exp "Life expectancy at birth, total (years)"
label variable ma_life_exp "Male Life Expectancy at birth"
label variable fe_life_exp "Female Life Expectancy at birth"
label variable urban_pop "Urban population (% of total population)"
label variable ghe_per "Domestic general government health expenditure (% of GDP)"
label variable undernourishment "Prevalence of undernourishment (% of population)"
label variable immune "Immunization, DPT (% of children ages 12-23 months)"
label variable pollution "PM2.5 air pollution, mean annual exposure (micrograms per cubic meter)"
label variable gni_pcap "GNI per capita, PPP (current international $)"
label variable unemployment "Unemployment, total (% of total labor force) (modeled ILO estimate)"
label variable bottom_50per_income "Bottom 50% income share"
label variable gni10000 "GNI per capita, PPP (current international $) measured in '0000 "
label variable mortality_rate "Mortality rate, infant (per 1,000 live births)"

/*Would be formulating a panel data regression. Will require country numbers for the same*/
egen float id_country = group(country_name)

/*To see the possibility of missing data use mdesc function*/
//Is a package. Will need to install it earlier
mdesc

/*Can see missing values in pollution and undernourishment*/
list year country_name if pollution == .
list year country_name if undernourishment  == .

/*Can have used dummies for income levels. However WB uses the Atlas Method for the same and those values were missing for a few countries*/

/*Will save the new dataset*/
save "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", replace

log close
