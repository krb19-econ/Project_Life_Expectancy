clear all
set more off
version 13.1

/*Begin log*/
log using "C:\Users\Administrator\Desktop\Life_Expectancy\cleaning.smcl", replace

/*Import dataset*/
import excel "C:\Users\Administrator\Desktop\Life_Expectancy\data_v1.xls", sheet("Sheet1") firstrow

describe //Can see that value labels are not indicated properly

/*Need to correct variable labels*/
label variable country_name "Life expectancy at birth, total (years)"
label variable country_name "Name of the country"
label variable year "Year"
label variable life_exp "Life expectancy at birth, total (years)"
label variable urban_pop "Urban population (% of total population)"
label variable ghe_per "Domestic general government health expenditure (% of GDP)"
label variable undernourishment "Prevalence of undernourishment (% of population)"
label variable immune "Immunization, DPT (% of children ages 12-23 months)"
label variable pollution "PM2.5 air pollution, mean annual exposure (micrograms per cubic meter)"
label variable gni_pcap "GNI per capita, PPP (current international $)"
label variable unemployment "Unemployment, total (% of total labor force) (modeled ILO estimate)"
label variable ghe_pcap "Domestic general government health expenditure per capita (current US$)"
label variable bottom_50per_income "Bottom 50% income share"


/*Would be formulating a panel data regression. Will require country numbers for the same*/
egen float id_country = group(country_name)

/*To see the possibility of missing data use mdesc function*/
//Is a package. Will need to install it earlier
mdesc

/*It is taking 0 as values rather than missing*/
mvdecode urban_pop ghe_per life_exp undernourishment immune pollution gni_pcap unemployment  ghe_pcap bottom_50per_income, mv(0)

/*Running the same code again*/
mdesc

/*Can see there are missing observations in pollution and undernourishment*/
*For now won't do anything to the missing data
*Let it remain.

*On observation, undernourishment for a large time period for select nations
*Pollution on the other hand is missing for 2018. Possibly not collected
*Can impute it later on

/*Will save the new dataset*/
save "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", replace

log close
