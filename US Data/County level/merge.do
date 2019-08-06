cd "C:\Users\WB459082\Documents\DECAT\bls\" 
use "counties.dta", clear
egen tag = tag(area_text)
keep if tag==1
keep area_text
split area_text, p(", ")
rename area_text1 county_name
rename area_text2 state
split county_name, p("/")
drop county_name
rename county_name1 county_name
split county_name, p(" Borough")
drop county_name
rename county_name1 county_name
bysort state county_name: gen count=_N
tab count
drop count
sort state
replace state="DC" if county_name=="District of Columbia"
replace county_name="Doña Ana County" if county_name=="Dona Ana County"
save "county_names", replace



import delimited "C:\Users\WB459082\Documents\DECAT\US Data\account-locations-identified.csv", encoding(UTF-8) clear
gsort -n
keep if country_short=="US"
*twoway (scatter latitude longitude, msize(vtiny))
rename administrative_area_level_2_long county_name
rename administrative_area_level_1_shor state

merge m:1 state county_name using "C:\Users\WB459082\Documents\DECAT\bls\county_names.dta"
tab _merge

tab county_name if _merge==1
/*


                            county_name |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                       Arlington County |          1      100.00      100.00
----------------------------------------+-----------------------------------
                                  Total |          1      100.00



