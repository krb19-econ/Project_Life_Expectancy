clear all
set more off
version 13.1

log using "C:\Users\Administrator\Desktop\Life_Expectancy\analysis.smcl", replace
use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

xtset id_country year
/*Endogeneous*/
summarize life_exp ma_life_exp fe_life_exp mortality_rate 
/*Exogeneous*/
summarize urban_pop gni10000 unemployment ghe_per , detail // Would get percentiles, skewness and kurtosis values also


/*By countries*/
table country_name, contents(mean life_exp mean ma_life_exp mean fe_life_exp mean mortality_rate )
table country_name, contents(mean urban_pop mean gni10000 mean unemployment mean ghe_per )
//Exported the above tables to excel to get meaningful results


/*Asia mean performance over the years*/
table year, contents(mean life_exp mean ma_life_exp mean fe_life_exp mean mortality_rate )
table year, contents(mean urban_pop mean gni10000 mean unemployment mean ghe_per )
/*Exported to excel to analyse*/


/*Can compare with that of India over the years*/
table year if country_name == "India", contents(mean life_exp mean ma_life_exp mean fe_life_exp mean mortality_rate )
table year if country_name == "India", contents(mean urban_pop mean gni10000 mean unemployment mean ghe_per )




/*Distributions of different variables. Create histograms for each using macros*/
cd "C:\Users\Administrator\Desktop\Life_Expectancy\Images\Histograms png"

foreach var in life_exp ma_life_exp fe_life_exp mortality_rate urban_pop gni_pcap unemployment ghe_per {
histogram `var' , frequency normal
graph export `var'.png, replace
}

/*Will use extremes function to observe extreme values taken by specific variables*/
/*NOTE: extremes function needs to be installed*/
extremes  ghe_per
list ghe_per year country_name if ghe_per >4.71 // 95th percentile

extremes gni_pcap
list year country_name gni_pcap if gni_pcap >82064 // 95th percentile

extremes unemployment
list unemployment year country_name if unemployment >15.7




/*To get mean values throughout the period*/
mean life_exp ma_life_exp fe_life_exp mortality_rate urban_pop gni10000 unemployment ghe_per 
mean life_exp ma_life_exp fe_life_exp mortality_rate urban_pop gni10000 unemployment ghe_per , vce(cluster id_country)
//Note: Seen later. Used cluster se


/*Now to look at Correlation*/
pwcorr life_exp ma_life_exp fe_life_exp mortality_rate urban_pop gni10000 unemployment ghe_per , sig star(5)
//Seems ok


/*Panel EA*/
xtsum life_exp ma_life_exp fe_life_exp mortality_rate urban_pop gni10000 ghe_per  unemployment  

log close
