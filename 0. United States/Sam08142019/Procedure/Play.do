clear all

	use "C:\Users\WB459082\Desktop\DECAT\0. United States\Data\Bureau of Labor Statistics\County level\unemployment.dta", clear
	save "locations.dta", replace

/* Extract US locations from account-locations-identified.csv
	cd "C:\Users\WB459082\Desktop\Sam08142019\Twitter\"
	import delimited "account-locations-identified.csv", encoding(UTF-8) clear
	replace country_short="US" if location=="New York"
	keep if country_short=="US"
	destring v1, gen(location_id)
	drop v1
	save "locations.dta", replace
*/

* Time series of mentions of Twitter users’ labor market status extracted from US tweets
* 754,306
* 2011 -2018
	import delimited "C:\Users\WB459082\Desktop\DECAT\0. United States\Sam08142019\Twitter\US.csv", encoding(UTF-8) clear
	tab month year
	
	merge m:1 location_id month year using "C:\Users\WB459082\Desktop\DECAT\0. United States\Data\Bureau of Labor Statistics\County level\unemployment.dta", force
	sort v1
	drop if _merge==2
	br if _merge==1
	
	
	drop _merge
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                           754,306  (_merge==3)
    -----------------------------------------*/

* Export to Tableau
*export delimited using "C:\Users\WB459082\Desktop\Sam08142019\Tableau\Dash1\Mentions.csv", replace

* 23 mention variables (2 of them are empty)
encode administrative_area_level_1_shor, gen(state)
label var state "State"
rename summention* t* 

local mentions "t_anyone_hiring t_i_am_unemployed t_i_got_fired t_i_got_laid_off t_i_have_been_fired t_i_have_been_laid_off t_i_have_gotten_laid_of t_i_was_fired t_i_was_laid_off t_ive_been_fired t_ive_been_laid_off t_ive_gotten_laid_off t_looking_for_a_job t_looking_for_a_new_job t_lost_my_job t_need_a_job t_need_a_new_job t_need_help_finding_a_j t_searching_for_a_job t_searching_for_a_new_j t_who_is_hiring t_whos_hiring sumn_tweets"

sum sum*, sep(0)

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

/*collapse (mean) d*

Variable							Freq
d_sumn_tweets						100.0000%
d_t_need_a_job						6.6148%
d_t_looking_for_a_job				3.2558%
d_t_need_a_new_job					2.1098%
d_t_looking_for_a_new_job			0.9871%
d_t_i_got_fired						0.8739%
d_t_lost_my_job						0.6866%
d_t_i_was_fired						0.5180%
d_t_who_is_hiring					0.2465%
d_t_i_got_laid_off					0.1945%
d_t_searching_for_a_job				0.1820%
d_t_anyone_hiring					0.1110%
d_t_i_was_laid_off					0.1002%
d_t_i_am_unemployed					0.0623%
d_t_searching_for_a_new_j			0.0594%
d_t_ive_been_fired					0.0468%
d_t_i_have_been_fired				0.0385%
d_t_need_help_finding_a_j			0.0168%
d_t_ive_been_laid_off				0.0139%
d_t_i_have_been_laid_off			0.0052%
d_t_ive_gotten_laid_off				0.0001%
d_t_i_have_gotten_laid_of			0.0000%  Remove
d_t_whos_hiring						0.0000%  Remove */


** Some of these twitter mentions are more relevant than others. I would drop those that are too rare, and perhaps sum or take the principal component of the most relevant ones. Then let’s see how it explains the cross section, and whether it helps predict changes over time (keeping only the past X<5 years of data). 
	* count: adding all the counts
	* pc1_counts: pca of counts
	* pc1_dummies: pca of dummies 

* Top 3
local most_freq "d_t_need_a_job d_t_looking_for_a_job d_t_need_a_new_job"

* 20 dummies
local all_dummies "d_t_need_a_job d_t_looking_for_a_job d_t_need_a_new_job d_t_looking_for_a_new_job d_t_i_got_fired d_t_lost_my_job d_t_i_was_fired	d_t_who_is_hiring d_t_i_got_laid_off d_t_searching_for_a_job d_t_anyone_hiring	d_t_i_was_laid_off d_t_i_am_unemployed	d_t_searching_for_a_new_j		d_t_ive_been_fired	d_t_i_have_been_fired d_t_need_help_finding_a_j	d_t_ive_been_laid_off d_t_i_have_been_laid_off	d_t_ive_gotten_laid_off"

* 20 counts
local all_counts "t_need_a_job t_looking_for_a_job t_need_a_new_job t_looking_for_a_new_job t_i_got_fired t_lost_my_job t_i_was_fired	t_who_is_hiring t_i_got_laid_off t_searching_for_a_job t_anyone_hiring	t_i_was_laid_off t_i_am_unemployed	t_searching_for_a_new_j		t_ive_been_fired	t_i_have_been_fired t_need_help_finding_a_j	t_ive_been_laid_off t_i_have_been_laid_off	t_ive_gotten_laid_off"

pca `all_dummies'
predict pc1 pc2, score
tab d_t_need_a_job d_t_looking_for_a_job, sum(pc1)
rename pc1 pc1_dummies
rename pc2 pc2_dummies
label var pc1_dummies "Index created with dummies"

pca `all_counts'
predict pc1 pc2, score
tab d_t_need_a_job d_t_looking_for_a_job, sum(pc1)
rename pc1 pc1_counts
rename pc2 pc2_counts
label var pc1_counts "Index created with counts"


*10.99% of observations (82,920 /754,306)
gen dummy_pc1=pc1_dummies
replace dummy_pc1=0 if pc1_dummies<0
replace dummy_pc1=1 if pc1_dummies>0
tab dummy_pc1

gen count= t_anyone_hiring+ t_i_am_unemployed+ t_i_got_fired+ t_i_got_laid_off+ t_i_have_been_fired+ t_i_have_been_laid_off+ t_i_have_gotten_laid_of+ t_i_was_fired+ t_i_was_laid_off+ t_ive_been_fired+ t_ive_been_laid_off+ t_ive_gotten_laid_off+ t_looking_for_a_job+ t_looking_for_a_new_job+ t_lost_my_job+ t_need_a_job+ t_need_a_new_job+ t_need_help_finding_a_j+ t_searching_for_a_job+ t_searching_for_a_new_j+ t_who_is_hiring+ t_whos_hiring
*replace count=1 if count>0
tab count, sum(pc1_counts)


*** FIGURES ***

/* Scatterplot shows outliers from "looking for a job" and "need a job" when using counts 
	gen obs = 1
	collapse (sum) obs, by(pc1_counts pc1_dummies)
	twoway (scatter pc1_counts pc1_dummies [fw=obs])
*/

/* Bar graph 
	graph bar (mean) pc1_dummies, over(count, label(angle(vertical) labsize(tiny))) name(bar_dummies)
	graph bar (mean) pc1_counts, over(count, label(angle(vertical) labsize(tiny))) name(bar_counts)
	gr combine bar_dummies bar_counts
*/ 

/* Binder
	collapse (mean) count pc1_dummies pc1_counts unemployment_rate, by(month year administrative_area_level_1_long state)
	order state year month
	sort  state year month
	gen day=1
	gen date=mdy(month,day,year)
	format date %td
	tsset state date
	levelsof administrative_area_level_1_long, local(states)

	cd "C:\Users\WB459082\Desktop\DECAT\0. United States\Sam08142019\Twitter\Graphs"
	foreach i of local states{
		tsline count pc1_dummies pc1_counts unemployment_rate if administrative_area_level_1_long=="`i'", title("`i'")
		graph export "`i'.pdf", replace
	}

*/
eststo clear
	
eststo: reg  pc1_dummies unemployment_rate
eststo: reg  pc1_counts unemployment_rate
eststo: reg count unemployment_rate

esttab, se
