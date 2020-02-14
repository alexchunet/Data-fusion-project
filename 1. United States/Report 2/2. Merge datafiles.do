capture log close
log using "C:\Users\WB459082\Desktop\DECAT\0. United States\Report 2\log Merge datafiles.txt", replace text
/*==================================================
project:       Merges datafiles and experiment with a few techniques to relate 
				tweet mentions to unemployment rate at the US monthly county level
Author:        Francisco Javier Parada Gomez Urquiza 
E-email:       fparadagomezurqu@worldbank.org
url:           
Dependencies:  World Bank
----------------------------------------------------
Creation Date:    14 Aug 2019 - 14:39:32
Modification Date:   17 Sep 2019
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
cd "C:\Users\WB459082\Documents\DECATFINAL\1. United States\Report 2\"

/*==================================================
              1: Merge mentions with locations and unemployment data 
==================================================*/
 
*----------1.1: Open locations
				import delimited "C:\Users\WB459082\Documents\DECATFINAL\1. United States\Sam08142019\Twitter\account-locations-identified.csv", encoding(UTF-8) clear
				
				replace country_short="US" if location=="New York"
				keep if country_short=="US" | country_short=="BR" | country_short=="MX" | country_short=="CO" | country_short=="AR" | country_short==""
				rename  administrative_area_level_2_long county_name
				rename  administrative_area_level_1_shor state
				rename v1 location_id
				recast str location_id
				desc location_id
				codebook location_id
				tempfile locations
				save "`locations'"

*----------1.2: Match mentions to location 
				import delimited "C:\Users\WB459082\Documents\DECATFINAL\1. United States\Sam08142019\Twitter\US.csv", encoding(UTF-8) clear
				tostring location_id, replace
				desc location_id
				codebook location_id
				merge m:1 location_id using "`locations'", force
				drop _merge

*----------1.3:	Match to unemployment (654,233 matches)
				desc state county_name year month
				replace administrative_area_level_1_long="Virginia" if county_name=="Arlington County" & state=="DC"
				replace state="VA" if county_name=="Arlington County" & state=="DC"
				merge m:1 state county_name year month using "US_counties_03.dta"	
				keep if _merge==3
				sort v1
				
/*==================================================
              2: Create new variables
==================================================*/

*----------2.1: Unemployment rate

				destring value, gen(unemployment_rate)  force
				

*----------2.2: Mention dummies (Yes/No) instead of count

				rename summention* t* 
				
				#delimit
				local mentions "t_anyone_hiring 
								t_i_am_unemployed 
								t_i_got_fired 
								t_i_got_laid_off 
								t_i_have_been_fired 
								t_i_have_been_laid_off 			      
								t_i_have_gotten_laid_of 
								t_i_was_fired 
								t_i_was_laid_off 
								t_ive_been_fired 
								t_ive_been_laid_off 
								t_ive_gotten_laid_off 
								t_looking_for_a_job 
								t_looking_for_a_new_job 		
								t_lost_my_job 
								t_need_a_job 
								t_need_a_new_job 
								t_need_help_finding_a_j 
								t_searching_for_a_job 
								t_searching_for_a_new_j 
								t_who_is_hiring 
								t_whos_hiring 
								sumn_tweets";
				#delimit cr

				* outliers
				sum t_need_a_job t_looking_for_a_job

				foreach i of local mentions{
					sum `i'
					gen d_`i'=`i'
					replace d_`i'=1 if d_`i'>0
					label var d_`i' "Dummy variable 1 if >0"
					display "   "
					display "`i'"
					sum d_`i'
				}
				
*----------2.3: Encode state

				encode state, gen(state_code)

/*==================================================
              3: PCA and Counts
==================================================*/

*----------3.1: PCA Dummies: Principal component that results from turning these mention counts into dummies to get rid of outliers
			* 20 dummies
			local all_dummies "d_t_need_a_job d_t_looking_for_a_job d_t_need_a_new_job d_t_looking_for_a_new_job d_t_i_got_fired d_t_lost_my_job d_t_i_was_fired	d_t_who_is_hiring d_t_i_got_laid_off d_t_searching_for_a_job d_t_anyone_hiring	d_t_i_was_laid_off d_t_i_am_unemployed	d_t_searching_for_a_new_j		d_t_ive_been_fired	d_t_i_have_been_fired d_t_need_help_finding_a_j	d_t_ive_been_laid_off d_t_i_have_been_laid_off	d_t_ive_gotten_laid_off"

			pca `all_dummies'
			predict pc1 pc2, score
			tab d_t_need_a_job d_t_looking_for_a_job, sum(pc1)
			rename pc1 pc1_dummies
			rename pc2 pc2_dummies
			label var pc1_dummies "Index created with dummies"
			
*----------3.2: PCA Counts: Principal component that results from all these mention counts
			* 20 counts
			local all_counts "t_need_a_job t_looking_for_a_job t_need_a_new_job t_looking_for_a_new_job t_i_got_fired t_lost_my_job t_i_was_fired	t_who_is_hiring t_i_got_laid_off t_searching_for_a_job t_anyone_hiring	t_i_was_laid_off t_i_am_unemployed	t_searching_for_a_new_j		t_ive_been_fired	t_i_have_been_fired t_need_help_finding_a_j	t_ive_been_laid_off t_i_have_been_laid_off	t_ive_gotten_laid_off"

			pca `all_counts'
			predict pc1 pc2, score
			tab d_t_need_a_job d_t_looking_for_a_job, sum(pc1)
			rename pc1 pc1_counts
			rename pc2 pc2_counts
			label var pc1_counts "Index created with counts"
			
*----------3.3: Count: This is the simple addition of all of the mention counts (two of the variables are completely empty). 
			*10.99% of observations (82,920 /754,306)
			gen dummy_pc1=pc1_dummies
			replace dummy_pc1=0 if pc1_dummies<0
			replace dummy_pc1=1 if pc1_dummies>0
			tab dummy_pc1

			gen count= t_anyone_hiring+ t_i_am_unemployed+ t_i_got_fired+ t_i_got_laid_off+ t_i_have_been_fired+ t_i_have_been_laid_off+ t_i_have_gotten_laid_of+ t_i_was_fired+ t_i_was_laid_off+ t_ive_been_fired+ t_ive_been_laid_off+ t_ive_gotten_laid_off+ t_looking_for_a_job+ t_looking_for_a_new_job+ t_lost_my_job+ t_need_a_job+ t_need_a_new_job+ t_need_help_finding_a_j+ t_searching_for_a_job+ t_searching_for_a_new_j+ t_who_is_hiring+ t_whos_hiring
			*replace count=1 if count>0
			tab count, sum(pc1_counts)
			
*----------3.4: Normalized Count: This is the simple addition of all of the mention counts (two of the variables are completely empty) divided by the volume of tweets (n_tweets). 

			gen count_normal= (t_anyone_hiring+ t_i_am_unemployed+ t_i_got_fired+ t_i_got_laid_off+ t_i_have_been_fired+ t_i_have_been_laid_off+ t_i_have_gotten_laid_of+ t_i_was_fired+ t_i_was_laid_off+ t_ive_been_fired+ t_ive_been_laid_off+ t_ive_gotten_laid_off+ t_looking_for_a_job+ t_looking_for_a_new_job+ t_lost_my_job+ t_need_a_job+ t_need_a_new_job+ t_need_help_finding_a_j+ t_searching_for_a_job+ t_searching_for_a_new_j+ t_who_is_hiring+ t_whos_hiring)/sumn_tweets


/*==================================================
              4: Figures
==================================================*/


/*----------4.1: Scatterplot shows outliers from "looking for a job" and "need a job" when using counts 
			gen obs = 1
			collapse (sum) obs, by(pc1_counts pc1_dummies)
			twoway (scatter pc1_counts pc1_dummies [fw=obs])
*/

/*----------4.2: Bar graph 

			graph bar (mean) pc1_dummies, over(count, label(angle(vertical) labsize(tiny))) name(bar_dummies)
			graph bar (mean) pc1_counts, over(count, label(angle(vertical) labsize(tiny))) name(bar_counts)
			gr combine bar_dummies bar_counts
			
*/
	
/*----------4.3: Binder

			collapse (mean) count count_normal pc1_dummies pc1_counts unemployment_rate, by(month year administrative_area_level_1_long state state_code)
			order state year month
			sort  state year month
			gen day=1
			gen date=mdy(month,day,year)
			format date %td
			
			tsset state_code date
			levelsof administrative_area_level_1_long, local(states)

			cd "C:\Users\WB459082\Desktop\DECAT\0. United States\Report 2\Graphs"
			foreach i of local states{
				tsline count count_normal pc1_dummies pc1_counts unemployment_rate if administrative_area_level_1_long=="`i'", title("`i'")
				graph export "`i'.pdf", replace
			}
			
*/

/*----------4.3=4: New Scatterplot

			collapse (mean) unemployment_rate (rawsum) count sumn_tweets,  by(month year administrative_area_level_1_long state state_code)
			gen count_normal_state= count/sumn_tweets
			scatter  unemployment_rate count_normal_state, by(month year, cols(8))
			export excel using "C:\Users\WB459082\Desktop\DECAT\0. United States\Report 2\tableau.xls", sheetmodify firstrow(variables) replace
*/				

/*==================================================
              5: Regressions
==================================================*/

*----------5.1: Summary

			sum pc1_dummies pc1_counts count count_normal unemployment_rate

*----------5.2: Correlation

			corre pc1_dummies pc1_counts count count_normal unemployment_rate

*----------5.2: Regressions

			local controls "unemployment_rate i.month i.state_code"
			
			eststo clear
			
			eststo: reg  pc1_dummies `controls'
			eststo: reg  pc1_counts `controls'
			eststo: reg count `controls'
			eststo: reg count_normal `controls'

			esttab using results.csv, se r2 replace
			
			tab year if e(sample)
			
			esttab

log close
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


