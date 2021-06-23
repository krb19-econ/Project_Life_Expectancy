clear all
set more off
version 13.1
log using "C:\Users\Administrator\Desktop\Life_Expectancy\analysis.smcl", replace
use "C:\Users\Administrator\Desktop\Life_Expectancy\data_cleaned.dta", clear

//EXPLANATORY ANALYSIS
/* 
1. India's position in various variables 
2. PCI vs Bottom 50% income share 
3. Correlation between variables  
4. Asia over time in different variables 
5. Any unique/strange changes in variables. Such as declining life expectancy or pci
6. India in a particular year vs Mean of that year 
7. Obtaining Growth Rates
*/
/*Declare data set as panel data */
xtset id_country year

summarize urban_pop-gni_pcap, detail // Would get percentiles, skewness and kurtosis values also

table country_name, contents(mean urban_pop mean ghe_per mean life_exp mean undernourishment mean immune )
table country_name, contents(mean pollution mean gni_pcap mean unemployment mean ghe_pcap mean bottom_50per_income )
//Exported the above tables to excel to get meaningful results


/*Asia mean performance over the years*/
table year, contents(mean urban_pop mean ghe_per mean life_exp mean undernourishment mean immune )
table year, contents(mean pollution mean gni_pcap mean unemployment mean ghe_pcap mean bottom_50per_income )
/*Exported to excel to analyse*/


/*Now to look at Correlation*/
//First look at Pearson Correlation coefficient
pwcorr urban_pop-gni_pcap, sig star(5)

/*But 2 possible issues with this*/
//By a scatterplot matrix, the relation between most variables is non linear
graph matrix urban_pop-gni_pcap, half

//Also variables need to be normal for Pearson correlation
//Testing for normality by Shapiro - Wilk W Test
swilk urban_pop-gni_pcap

//2 options- Transform or Spearman. Here take spearman
spearman urban_pop-gni_pcap, stats(rho p) star(0.05) pw matrix

//The obtained correlations are quite different in Spearman as compared to Pearson


/*Distributions of different variables. Create histograms for each using macros*/
cd "C:\Users\Administrator\Desktop\Life_Expectancy\Images\Histograms png"

foreach var in urban_pop ghe_per life_exp undernourishment immune pollution unemployment ghe_pcap bottom_50per_income gni_pcap {
histogram `var' , frequency kdensity
graph export `var'.png
}

/*Should once look at these unique values. Mentioned in report*/
/*Will use extremes function to observe extreme values taken by specific variables*/
/*NOTE: extremes function needs to be installed*/
extremes  ghe_per
list ghe_per year country_name if ghe_per >4.71 // 95th percentile

extremes ghe_pcap
list year country_name ghe_pcap if ghe_pcap > 1504 // 95th percentile
list year country_name ghe_pcap if ghe_pcap > 3000

extremes gni
list year country_name gni_pcap if gni_pcap >82064 // 95th percentile

extremes unemployment
list unemployment year country_name if unemployment >15.7

extremes immune
list year country_name immune if immune <68

/*Panel EA*/
xtsum urban_pop-gni_pcap

log close
