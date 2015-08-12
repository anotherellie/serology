**********************************************************************************
*EXCEL TABLE FOR PANEL DATA. 
*************************************************************************************
*oral=1
*rectal=2
*external=3
*urine=4
clear
cap log close
set more off
cd "N:\Eking\Prevalence_study_data"
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
log using "N:\Eking\Prevalence_study_data\Log_files\GEE_riskf.log", replace
*


*clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1

*____________________________________________________
*Deal with cvariables that give erros in the follwing regressions by combining or removing the grouped vars and sticking to the continuous. Ie. drop all gp*numpatnrs_lstyr vars
recode position 3=2
lab define posit 1"insertive only" 2"receptive or versatile"
lab values position posit

gen educ2=educ
lab var educ2 "more than 3_binary"
recode educ2 4=. 2=1 3=2
lab define educ2 1"Up to 2 years" 2 "3 or more years"
lab values educ2 educ2

recode cdm_ptnr1 3=2
lab define cdmw 1"always" 2"not always"
lab values cdm_ptnr1 cdmw

recode self_rated_hlth 4=3
lab define hlthw 1"very good" 2"good" 3"fair/bad"
lab values self_rated_hlth hlthw

recode ethgp_ptnr1 3=2 4=3
lab define etw 1"white" 2"black/Asian/SE Asian" 3"mixed/other"
lab values ethgp_ptnr1 etw

recode ethnicgp2 3=2 4=3
lab values ethnicgp et

recode gp_nummen_life 2=1 3/4=2
lab define numw 1"<31" 2">=31"
lab values gp_nummen_life numw
*______________________________________________


local varlist gp_anlptnrs_lstyr2 gp_new_anlptnrs_lstyr2 gp_anlptnrs_nocdm_lstyr2 gp_osptnrs_lstyr2

foreach var in `varlist'{
recode `var' 0=1 1=2
lab values `var' numw
}


local sero sero_16_bin sero_18_bin

*levels of coding doesn't work below if binary are coded as 0 and 1 so need to change to 1 and 2
local bin hiv anl_drug binary_alc circ2 concur stillsex_ptnr1  bin_nocdm_ptnrs_lstyr bornUK smk empl genital_HPV16 genital_HPV18 genital_HRtypes oral_HPV16 oral_HPV18
foreach b in `bin'{
recode `b' 1=2 
recode `b' 0=1
}


				
local categ  hiv educ2 gp_nummen_life gp_anlptnrs_lstyr2 gp_new_anlptnrs_lstyr2 gp_anlptnrs_nocdm_lstyr2 lst_os_man3 lst_rec_anl3 lst_ins_anl3 lst_anl_wmn_miss position stillsex_ptnr1 anl_drug concur


	
putexcel A1=("sero") B1=("exp")  C1=("level_exp") D1=("or_est") E1=("lci") F1=("uci") G1=("adjusted") H1=("HPV") using forestsero, replace
	local row=2
	foreach y of varlist `sero'{
	levelsof gp_nummen_life, local(levels)
		logistic `y' i.gp_nummen_life age 
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
						
				putexcel A`row'=("`y'") B`row'=("gp_nummen_life") C`row'=(`l') D`row'=(`OR')  E`row'=(`lc') F`row'=(`uc') G`row'=("aOR")  using forestsero, modify
				loc row = `row' + 1
						}
						}
						
*gets to row 4 start at 5
local categ hiv educ2 gp_anlptnrs_lstyr2 gp_new_anlptnrs_lstyr2 gp_anlptnrs_nocdm_lstyr2  lst_rec_anl3 lst_ins_anl3 lst_os_man3 concur position  anl_drug stillsex_ptnr1
						
	foreach y of varlist `sero'{
	foreach t in `categ'{
	levelsof `t', local(levels)
		logistic `y' i.`t' i.gp_nummen_life age 
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
						
				putexcel A`row'=("`y'") B`row'=("`t'") C`row'=(`l') D`row'=(`OR')  E`row'=(`lc') F`row'=(`uc') G`row'=("aOR")  using forestsero, modify
				loc row = `row' + 1
						}
						}
			}
				

				
				
				

      
		

					
