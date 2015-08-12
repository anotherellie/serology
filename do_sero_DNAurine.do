clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
keep if ad_16==1|ad_18==1

local sero sero_16_bin sero_18_bin sero_16_18_bin

*levels of coding doesn't work below if binary are coded as 0 and 1 so need to change to 1 and 2
local bin urine_HPV16 urine_HPV18 urine_HPV16_18 urine_HPV6_11 urine_vactypes urine_nonovalent urine_HRtypes 
foreach b in `bin'{
recode `b' 1=2 
recode `b' 0=1
}



	
putexcel A1=("risk factor")  B1=("level") C1=("seroneg-n (%)") D1=("seropos n(%)") E1=("OR") F1=("95%CI") G1=("aOR") H1=("a95%CI") using sero_DNAurine, replace
	
local row = 2
	foreach y of varlist `sero'{
		foreach i of varlist `bin'{
				levelsof `i', local(levels)
				
				 quietly logistic `y' i.`i' if adequatepcr4==1
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
					quietly ci `y' if `i'==`l', binomial
						local n_pos= r(N)*r(mean)
						local n_pos : display %3.0f `n_pos'
						local per_pos=r(mean)*100
						local per_pos : display %3.1f `per_pos'

						local n_neg= r(N)-(r(N)*r(mean))
						local per_neg= (1-r(mean))*100
						local per_neg : display %3.1f `per_neg'
						
					quietly logistic `y' i.`i' age i.gp_nummen_life if adequatepcr4==1
				matrix ab=r(table)
				
						local aOR=ab[1,`l']
						local aOR : display %9.2f `aOR'

						local alc=ab[5,`l']
						local alc : display %3.2f  `alc'

						local auc=ab[6,`l']
						local auc : display %3.2f  `auc'
				
				putexcel A`row'=("`i'") B`row'=(`l') C`row'=("`n_neg' (`per_neg')") D`row'=("`n_pos' (`per_pos')")  E`row'=(`OR') F`row'=("(`lc'-`uc')") G`row'=(`aOR') H`row'=("(`alc'-`auc')") using sero_DNAurine, modify
				loc row = `row' + 1
						}
						}
						}
						
	
			
				

				
				
				
