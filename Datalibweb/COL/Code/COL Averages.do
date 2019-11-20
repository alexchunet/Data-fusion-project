capture log close
log using "D:\SOUTH ASIA MICRO DATABASE\05.projects_requ\02.FY20_projects\COL Averages\COL Averages.txt", replace text
/*==================================================
Project:       Measures variables over time 
Author:        Francisco Javier Parada Gomez Urquiza 
E-email:       fparadagomezurqu@worldbank.org
url:           
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:      15 Nov 2019 - 15:50:01
Modification Date:  18 Nov 2019
Do-file version:    01
References:          
Output:             COL Averages.xlsx
==================================================*/

/*==================================================
              0: Program set up
==================================================*/
drop _all
clear all

*----------0.1: Set directory

if ("`c(hostname)'" == "wbgmsbdat001") {
	global hostdrive "D:"
}
else {
	global hostdrive "\\Wbgmsbdat001"
}
cd "${hostdrive}\SOUTH ASIA MICRO DATABASE\05.projects_requ\02.FY20_projects\COL Averages\" 


*----------0.2: Blank template

gen Year = .
save "COL Averages.dta", replace



/*==================================================
              1: Generate means for variables 
==================================================*/

*----------1.1: Create list of variables to study

local variables "ocupado desocupa pea"


*----------1.2: Run loop by urban/rural + total

foreach year in 2012 2013 2014 2015 2016 2017 2018 {
	foreach quarter in Q01 Q02 Q03 Q04{
		
		display "Colombia `year' PNADC `quarter'"
        
		
	 	foreach var of local variables{
			dis "``country'_`year'_address'--`var'"
			
			* By urban/rural
			clear all
			cap: dlw, coun(COL) y(`year') t(LABLAC-01) mod(ALL) verm(01) vera(02) sur(PNADC) per(`quarter') clear
				if (_rc) continue
				cap collapse (count) N = `var' (mean) mean = `var' [aw=pondera], by(urbano reg_uf)
				if (_rc) continue
				sum
			
			gen Country = "COL"
			gen Variable = "`var'"
			gen Year = `year'
			gen Quarter = "`quarter'"
			decode urbano, gen(Urban)
			drop urbano
			order Country Year Urban Variable

			append using "COL Averages.dta", force
			save         "COL Averages.dta", replace
			
			* Total
			clear all
			cap: dlw, coun(COL) y(`year') t(LABLAC-01) mod(ALL) verm(01) vera(02) sur(PNADC) per(`quarter') clear
				if (_rc) continue
				cap collapse (count) N = `var' (mean) mean = `var' [aw=pondera], by(reg_uf)
				if (_rc) continue
				sum
			
			gen Urban = "Total"
			gen Country = "COL"
			gen Variable = "`var'"
			gen Year = `year'
			gen Quarter = "`quarter'"
			order Country Year Urban Variable

			append using "COL Averages.dta", force
			save         "COL Averages.dta", replace
			
		}	
		
	}
}

*----------1.3: Export to Excel 

use "COL Averages.dta", clear
*numlabel, add 
decode reg_uf, gen( State)

replace State = "Amapá" if reg_uf == 16
replace State = "Ceará" if reg_uf == 23
replace State = "Espírito Santo" if reg_uf == 32
replace State = "Goiás" if reg_uf == 52
replace State = "Maranhão" if reg_uf == 21
replace State = "Pará" if reg_uf == 15
replace State = "Paraíba" if reg_uf == 25
replace State = "Paraná" if reg_uf == 41
replace State = "Piauí" if reg_uf == 22
replace State = "Rondônia" if reg_uf == 11
replace State = "São Paulo" if reg_uf == 35

sort Country Year Variable Urban  
tab Year Quarter
drop reg_uf

export excel using "COL Averages.xlsx", firstrow(variables) replace


