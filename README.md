# DECAT
Data Fusion project

Quarterly for Argentina and Brazil. Monthly for United States, Colombia and Mexico.

# Strata

if "`country'"=="ARG" local strata "reg_aglomerado"  

if "`country'"=="BRA" local strata "reg_uf" 

Acre, Alagoas, Amap�, Amazonas, Bahia, Cear�, Distrito Federal, Esp�rito Santo, Goi�s, Maranh�o, Mato Grosso, Mato Grosso do Sul, Minas Gerais, Paran�, Para�ba, Par�, Pernambuco, Piau�, Rio Grande do Norte, Rio Grande do Sul, Rio de Janeiro, Rond�nia, Roraima, Santa Catarina, Sergipe, S�o Paulo, Tocantins


if "`country'"=="COL" local strata "reg_dpto"  

if "`country'"=="MEX" local strata "reg_ent"  


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
