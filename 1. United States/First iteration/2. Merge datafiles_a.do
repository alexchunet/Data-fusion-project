/*==================================================
project:       Merges datafiles and experiment with a few techniques to relate 
				tweet mentions to unemployment rate at the US monthly county level
Author:        J. Parada and A. Chunet
Dependencies:  World Bank
----------------------------------------------------
Creation Date:    14 Aug 2019 - 14:39:32
Modification Date:   20 February 2020
Do-file version:    01
References:          
Output:             
==================================================*/

/*==================================================
              0: Program set up
==================================================*/
*version 16
drop _all
clear all
cd "/Volumes/Elements/Documents/ArcGIS/Twitter Model/Data-fusion-project-master/1. United States/Report 1/"

/*==================================================
              1: Merge mentions with locations and unemployment data 
==================================================*/

*----------1.1: Open locations
				import delimited "account-locations-identified.csv", clear
				replace country_short="US" if location=="New York"
				keep if country_short=="US"
				rename  administrative_area_level_2_long county_name
				rename  administrative_area_level_1_shor state
				rename v1 location_id
				recast str location_id
				desc location_id
				codebook location_id

*----------1.2: Match with PIN county location (spatially joined in ArcGIS)
				merge 1:1 location_id using "loc_joined.dta", nogenerate keep(match)
				replace county_name=county_joined if (county_name=="" & locality_long!="")
				tempfile locations
				save "`locations'"

*----------1.3: Match mentions to location 
				import delimited "US.csv", clear
				tostring location_id, replace
				desc location_id
				codebook location_id
				merge m:1 location_id using "`locations'", force
				drop _merge

*----------1.4:	Match to unemployment (654,233 matches)
				desc state county_name year month
				replace administrative_area_level_1_long="Virginia" if county_name=="Arlington County" & state=="DC"
				replace state="VA" if county_name=="Arlington County" & state=="DC"
				merge m:1 state county_name year month using "US_counties_03.dta"
				drop if _merge==2
				sort v1

