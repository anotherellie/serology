clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1

*RECODE
recode ethnicgp2 3=2 4=3
lab values ethnicgp et

local varlist gp_anlptnrs_lstyr2 gp_new_anlptnrs_lstyr2 gp_anlptnrs_nocdm_lstyr2 gp_osptnrs_lstyr2
lab define numw 1"<31" 2">=31"
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


#delimit ;				
local categ  ethnicgp2  bornUK smk binary_alc empl educ sexty2 circ2 gp_anlptnrs_lstyr2 gp_new_anlptnrs_lstyr2 gp_anlptnrs_nocdm_lstyr2 gp_osptnrs_lstyr2 lst_os_man3 lst_rec_anl3 lst_ins_anl3 lst_vag3 lst_os_wmn3 lst_anl_wmn3 position genital_HPV16 genital_HPV18 genital_HRtypes oral_HPV16 oral_HPV18 hiv 
anl_drug 
cdm_ptnr1 type_ptnr1 stillsex_ptnr1 concur
;
#delimit cr

local cont age age_os_man age_rec_anl age_ptnr1 lstsex_days_ptnr1 age_frst_gum

foreach y of varlist `sero'{
tabout `categ' `y' using sero_num.txt, append c(freq row) f (0 2) npos (row)
}
putexcel A1=("risk factor")  B1=("level") C1=("OR") D1=("95% CI") E1=("p-testparm") F1=("p-fishers") using sero_OR_cont_ageptnr, replace

local row = 2

foreach y of varlist `sero'{
	foreach i of varlist `cont'{
				quietly logistic `y' `i' 
				matrix b=r(table)

				local OR=b[1,1]
				local OR : display %9.2f `OR'

				local lc=b[5,1]
				local lc : display %3.2f  `lc'

				local uc=b[6,1]
				local uc : display %3.2f  `uc'
			
				capture testparm `i'
					local p=r(p)
				local p : display %9.2f `p'
				
				
				
				putexcel A`row'=("`i'") B`row'=(99) C`row'=(`OR') D`row'=("(`lc'-`uc')")  E`row'=(`p')   using sero_OR_cont_ageptnrs, modify
				loc row = `row' + 1
						
				}
	}
	
putexcel A1=("risk factor")  B1=("level") C1=("OR") D1=("95% CI") E1=("p-testparm") F1=("p-fishers") using sero_OR_categ_ageptnrs, replace
	
local row = 2
	foreach y of varlist `sero'{
		foreach i of varlist `categ'{
				levelsof `i', local(levels)
				
				 quietly logistic `y' i.`i' age i.gp_nummen_life
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
						capture testparm i.`i'
					local p=r(p)
				local p : display %9.2f `p'
				
				quietly tab `y' `i', exact
				local exact=r(p_exact)
				local exact : display %9.2f `exact'
				
				putexcel A`row'=("`i'") B`row'=(`l') C`row'=(`OR') D`row'=("(`lc'-`uc')")  E`row'=(`p') F`row'=(`exact') using sero_OR_categ_ageptnrs, modify
				loc row = `row' + 1
						}
						}
						}
						
	
			
				

				
				
				
