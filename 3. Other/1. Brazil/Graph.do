
cd "C:\Users\WB459082\Desktop\NEW FY\Districts\Brasil\"
use "brasil.dta", clear
gen day=1
gen date = mdy(number, day, year)
format date %dM_d,_CY
tsset date, monthly 
graph twoway tsline recifepe salvadorba belohorizontemg riodejaneirorj saopaulosp portoalegrers, title("Taxa de desocupação das pessoas de 10 anos ou mais") ytitle("Unemployment rate %") tlabel(, format(%dm-CY) labsize(small)) ttitle("IBGE, Pesquisa Mensal de Emprego,  2002/mar a 2016/fev.", size(small))

graph export graph.pdf, replace