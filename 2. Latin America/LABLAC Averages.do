capture log close
*log using "D:\Javier2\LABLAC Averages\LABLAC Averages.txt", replace text
/*==================================================
Project:       Measures labor variables over time 
Author:        Francisco Javier Parada Gomez Urquiza 
E-email:       fparadagomezurqu@worldbank.org
url:           
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:      15 Nov 2019 - 15:50:01
Modification Date:  11 Dec 2019
Do-file version:    01
References:          
Output:             LABLAC Averages.xlsx
Details: 			Monthly for Colombia and Mexico
					Quarterly for Argentina and Brazil
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
*cd "${hostdrive}\Javier2\LABLAC Averages\" 

* Folder for Sam
cd "C:\Users\wb459082\Documents\LAB LAC Averages\"

*----------0.2: Blank template

gen Year = .
save "LABLAC Averages.dta", replace


/*==================================================
              1: Generate means for variables 
==================================================*/

*----------1.1: Create list of variables to study

local variables "ocupado desocupa pea"

*----------1.2: Run loop by urban/rural + total
foreach country in ARG BRA COL MEX{

	if "`country'"=="ARG" local survey "EPHC"  
	if "`country'"=="BRA" local survey "PNADC" 
	if "`country'"=="COL" local survey "GEIH"  
	if "`country'"=="MEX" local survey "ENOE"  
	
	if "`country'"=="ARG" local strata "reg_aglomerado"  
	if "`country'"=="BRA" local strata "reg_uf" 
	if "`country'"=="COL" local strata "reg_dpto"  
	if "`country'"=="MEX" local strata "reg_ent"  
	
	foreach year in 2012 2013 2014 2015 2016 2017 2018  {
		foreach quarter in Q01 Q02 Q03 Q04{
		
			display "`country' `year' `survey' `quarter'"
        
			foreach var of local variables{
						
			* By urban/rural
			clear all
			cap dlw, coun(`country') y(`year') t(LABLAC-01) mod(ALL) per(`quarter') sur(`survey')  clear
			if (_rc) continue
			cap collapse (count) N = `var' (mean) mean = `var' [aw=pondera], by(`strata' urbano mes)
			if (_rc) continue
			sum
			
			rename `strata' Strata
			gen Country = "`country'"
			gen Variable = "`var'"
			gen Year = `year'
			gen Quarter = "`quarter'"
			decode urbano, gen(Urban)
			drop urbano
			cap decode Strata, gen(Strata2)
			if (_rc) continue
				drop Strata
				rename Strata2 Strata
			order Country Year Urban Variable

			append using "LABLAC Averages.dta", force
			save         "LABLAC Averages.dta", replace
			
			* Total
			clear all
			cap dlw, coun(`country') y(`year') t(LABLAC-01) mod(ALL) per(`quarter') sur(`survey')  clear
			if (_rc) continue
			cap collapse (count) N = `var' (mean) mean = `var' [aw=pondera], by(`strata' mes)
			if (_rc) continue
			sum
			
			rename `strata' Strata
			gen Urban = "Total"
			gen Country = "`country'"
			gen Variable = "`var'"
			gen Year = `year'
			gen Quarter = "`quarter'"
			cap decode Strata, gen(Strata2)
			if (_rc) continue
				drop Strata
				rename Strata2 Strata
			order Country Year Urban Variable

			append using "LABLAC Averages.dta", force
			save         "LABLAC Averages.dta", replace
			
			}	
		}
	}
}
*----------1.3: Export to Excel 

use "LABLAC Averages.dta", clear


rename Strata Strata2
ds Strata2, has(type string)
foreach x in `r(varlist)' {
     forvalues i=128/255 {
         replace `x' = subinstr(`x', char(`i'), " ", .)
     }
}


replace Strata2="Bahia Blanca - Cerri" if Strata2=="Bah a Blanca - Cerri"
replace Strata2="Gran Cordoba" if Strata2=="Gran C rdoba"
replace Strata2="Gran Parana" if Strata2=="Gran Paran "
replace Strata2="Gran Tucuman - Tafi Viejo" if Strata2=="Gran Tucum n - Taf  Viejo"
replace Strata2="Jujuy - Palpala" if Strata2=="Jujuy - Palpal "
replace Strata2="Mar del Plata - Batan" if Strata2=="Mar del Plata - Bat n"
replace Strata2="Neuquen - Plottier" if Strata2=="Neuqu n - Plottier"
replace Strata2="Rio Cuarto" if Strata2=="R o Cuarto"
replace Strata2="Rio Gallegos" if Strata2=="R o Gallegos"
replace Strata2="San Nicolas - Villa Constituci0n" if Strata2=="San Nicol s - Villa Constituci n"
replace Strata2="Ushuaia - Rio Grande" if Strata2=="Ushuaia - R o Grande"
replace Strata2="Amapa" if Strata2=="Amap "
replace Strata2="Ceara" if Strata2=="Cear "
replace Strata2="Espirito Santo" if Strata2=="Esp rito Santo"
replace Strata2="Goias" if Strata2=="Goi s"
replace Strata2="Maranhao" if Strata2=="Maranh o"
replace Strata2="Parana" if Strata2=="Paran "
replace Strata2="Paraiba" if Strata2=="Para ba"
replace Strata2="Para" if Strata2=="Par "
replace Strata2="Piaui" if Strata2=="Piau "
replace Strata2="Rondonia" if Strata2=="Rond nia"
replace Strata2="Sao Paulo" if Strata2=="S o Paulo"
replace Strata2="Michoacan" if Strata2=="Michoac n"
replace Strata2="Mexico" if Strata2=="M xico"
replace Strata2="Nuevo Leon" if Strata2=="Nuevo Le n"
replace Strata2="Querataro de Arteaga" if Strata2=="Quer taro de Arteaga"
replace Strata2="San Luis Potosi" if Strata2=="San Luis Potos "
replace Strata2="Yucatan" if Strata2=="Yucat n"


label drop _all

sort Country Year Variable Urban  

export excel using "LABLAC Averages.xlsx", firstrow(variables) replace


