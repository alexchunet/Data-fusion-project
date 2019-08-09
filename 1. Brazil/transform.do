cd "C:\Users\WB459082\Desktop\NEW FY\Districts\Brasil\Data_Raw\"

import excel "BRA_Unemployment_Rate.xlsx", sheet("Data") firstrow clear

rename * R*
rename RMonth Month
rename Rnumber number
rename RYear Year

reshape long R, i(Year number Month) j(City) string
split City, parse("_")
drop City
rename City1 City
rename City2 State
rename City3 Category
rename R Rate

order City State Category Year number Month Rate
sort City State Category Year number Month Rate

replace Category="11 anos ou mais" if Category=="11anosoumai" | Category=="11anosoumais"

replace Category="Menos de 8" if Category=="Seminstrucao" | Category=="Seminstrucaoe" | Category=="Seminstrucaoemen" | Category=="Seminstrucaoemeno" | Category=="Seminstrucaoemenos"

replace Category="Total das Areas" if City=="Totaldasareas"

tab Category
export excel using "Tableau.xls", firstrow(variables) replace