# DECAT
Data Fusion project

Quarterly for Argentina and Brazil. Monthly for United States, Colombia and Mexico.

# Strata

if "`country'"=="ARG" local strata "reg_aglomerado"  

Bah�a Blanca - Cerri, Ciudad de Buenos Aires, Comodoro Rivadavia - Rada Tilly, Concordia, Corrientes, Formosa, Gran Catamarca, Gran C�rdoba, Gran La Plata, Gran Mendoza, Gran Paran�, Gran Resistencia, Gran Rosario, Gran San Juan, Gran Santa Fe, Gran Tucum�n - Taf� Viejo, Jujuy - Palpal�, La Rioja, Mar del Plata - Bat�n, Neuqu�n - Plottier, Partidos del GBA, Posadas, Rawson - Trelew, R�o Cuarto, R�o Gallegos, Salta, San Luis - El Chorrillo, San Nicol�s - Villa Constituci�n, Santa Rosa - Toay, Santiago del Estero - La Banda, Ushuaia - R�o Grande, Viedma - Carmen de Patagones


if "`country'"=="BRA" local strata "reg_uf" 

Acre, Alagoas, Amap�, Amazonas, Bahia, Cear�, Distrito Federal, Esp�rito Santo, Goi�s, Maranh�o, Mato Grosso, Mato Grosso do Sul, Minas Gerais, Paran�, Para�ba, Par�, Pernambuco, Piau�, Rio Grande do Norte, Rio Grande do Sul, Rio de Janeiro, Rond�nia, Roraima, Santa Catarina, Sergipe, S�o Paulo, Tocantins


if "`country'"=="COL" local strata "reg_dpto"  

5, 8, 11, 13, 15, 17, 18, 19, 20, 23, 25, 27, 41, 44, 47, 50, 52, 54, 63, 66, 68, 70, 73, 76


if "`country'"=="MEX" local strata "reg_ent"  

Aguascalientes, Baja California, Baja California Sur, Campeche, Cohauila, Colima, Chiapas, Chihuahua, Distrito Federal, Durango, Guanajuato, Guerrero, Hidalgo, Jalisco, M�xico, Michoac�n, Morelos, Nayarit, Nuevo Le�n, Oaxaca, Puebla, Quer�taro de Arteaga, Quintana Roo, San Luis Potos�, Sinaloa, Sonora, Tabasco, Tamaulipas, Tlaxcala, Veracruz-Llave, Yucat�n, Zacatecas


## Countries
| Country       	| Description 	|
|---------------	|-------------	|
| United States 	| Found monthly disaggregated emploment data at https://www.bls.gov/lau/ |
| Brazil        	| The rate of unemployment in Brazil is determined by the Monthly Employment Survey, coordinated by the Brazilian Institute of Geography and Statistics [IBGE](https://www.ibge.gov.br). The Pesquisa Mensal de Emprego (PME) is the monthly labor force survey covering the six largest Brazilian cities. See https://ww2.ibge.gov.br/home/estatistica/indicadores/trabalhoerendimento/pme_nova/default.shtm |
| Colombia      	|https://www.dane.gov.co/    	https://www.dane.gov.co/index.php/estadisticas-por-tema/mercado-laboral/empleo-y-desempleo/geih-historicos|
| Mexico        	| Quarterly, not monthly. Encuesta Nacional de Ocupación y Empleo (ENOE), población de 15 años y más de edad https://www.inegi.org.mx/temas/empleo/      https://www.inegi.org.mx/sistemas/Infoenoe/Default_15mas.aspx|
| Argentina     	| Argentina's Unemployment Rate is updated quarterly for 31 urban agglomerates https://www.indec.gob.ar/|
| Indonesia     	|             	|
| Malaysia      	|             	|
| Thailand      	|             	|
| Philippines    	|             	|
