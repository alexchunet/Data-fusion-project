import delimited "C:\Users\WB459082\Documents\DECAT\US Data\account-locations-identified.csv", encoding(UTF-8) clear
gsort -n
keep if country_short=="US"
twoway (scatter latitude longitude, msize(vtiny))