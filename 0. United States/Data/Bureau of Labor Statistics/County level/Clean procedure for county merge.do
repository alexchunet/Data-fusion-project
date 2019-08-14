capture log close
/*==================================================
project:       This do-file matches county names in account-locations-identified.csv to the county level unemployment data
Author:        Francisco Javier Parada Gomez Urquiza
E-email:       fparadagomezurqu@worldbank.org
url:          
Dependencies:  World Bank
----------------------------------------------------
Creation Date:     6 Aug 2019 - 16:12:51
Modification Date:  14 Aug 2019
Do-file version:    01
References:         
Output:            
==================================================*/
 
/*==================================================
              0: Program set up
==================================================*/
*version 16
drop _all
 
cd "C:\Users\WB459082\Desktop\DECAT\0. United States\Data\Bureau of Labor Statistics\County level\"
log using "Clean procedure for county level merge.txt", replace text


/*==================================================
              1: Download county level data from BLS website and save it 
==================================================*/
 /* 

	curl https://download.bls.gov/pub/time.series/la/la.data.64.County -O
	curl https://download.bls.gov/pub/time.series/la/la.area -O

	The last two digits are the measure codes:
		
		03 – unemployment rate
		04 – unemployment (level)
		05 – employment
		06 – labor force
*/
 
/*==================================================
              2: Import unemploment datasets into Stata and save as Stata database
==================================================*/
 /* 
			- add csv extention
			- import delimited "la.area.csv", clear 
			- import delimited "la.data.64.csv", clear 
*/

 
/*==================================================
              3: Merge both datasets and keep desired variable unemployment rate (03)
==================================================*/
			cd "C:\Users\WB459082\Desktop\DECAT\0. United States\Data\Bureau of Labor Statistics\County level\LAU Data\"
			use "la_data_64_County.dta", clear

			split series_id, p("LAU")
			gen series=substr(series_id, 19,2)
			gen area_code=substr(series_id2,1,15)
			merge m:1 area_code using "la_area.dta" /* This dataset contains the county names */
			keep if _merge==3
			*split area_text, p(", ")

			keep if series=="03"
			order area_text year period value
			keep area_text year period value
			compress

 
/*==================================================
              4: Clean dataset
==================================================*/
			rename year year2
			destring year2, gen(year)
			destring value, gen(unemployment_rate)  force
			drop year2
			
			egen tag = tag(area_text)
			*keep if tag==1
			
			split area_text, p(", ")
			rename area_text1 county_name
			rename area_text2 state
			
			split county_name, p("/")
			drop county_name
			rename county_name1 county_name
			
			split county_name, p(" Borough")
			drop county_name county_name2
			rename county_name1 county_name
			
			bysort state county_name: gen count=_N
			tab count
			drop count
			
			sort state
			replace state="DC" if county_name=="District of Columbia"
			replace county_name="DoÃ±a Ana County" if county_name=="Dona Ana County"

			order state county_name area_text year period unemployment_rate
			cd "C:\Users\WB459082\Desktop\DECAT\0. United States\Data\Bureau of Labor Statistics\County level\"
			save "counties_03.dta", replace

 
/*==================================================
              5: Open USA Twitter users data 
==================================================*/

			import delimited "C:\Users\WB459082\Desktop\DECAT\0. United States\Data\Twitter\account-locations-identified.csv", clear
			gsort -n
			replace country_short="US" if location=="New York"
			keep if country_short=="US" /* 10,335 */ 
			
			*MAP 
			*twoway (scatter latitude longitude, msize(vtiny))

			rename administrative_area_level_2_long county_name
			rename administrative_area_level_1_shor state
 
/*==================================================
              6: Merge Twitter users data with unemployment data
==================================================*/
 			
			
			merge m:m state county_name using "counties_03.dta"
			tab _merge

			tab county_name if _merge==1
			
			/* One mistake because Arlington County was coded as part of DC


                            county_name |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                       Arlington County |          1      100.00      100.00
----------------------------------------+-----------------------------------
                                  Total |          1      100.00
			*/ 
			
			drop if _merge==2
			tab _merge
			
					/* 86% were matched!
						 _merge |      Freq.     Percent        Cum.
		------------------------+-----------------------------------
				master only (1) |      1,371       13.27       13.27
					matched (3) |      8,964       86.73      100.00
		------------------------+-----------------------------------
						  Total |     10,335      100.00
						  */


 
/*==================================================
              7: Save database
==================================================*/
			sort v1
			rename county_name administrative_area_level_2_long
			rename state administrative_area_level_1_shor
			destring v1, gen(location_id)
			drop v1 _merge
			
			split period, p("M")
			destring period2, gen(month)
			drop period period1 period2
			drop if month==13

			save "unemployment.dta", replace
 
 
 
 
log close
exit
/* End of do-file */
 
><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< 
 
Notes:
1.
2.
3.
 
 
Version Control:









			

			

			



						  
						  
						  
