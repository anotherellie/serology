cap log close
clear
set more off

clear
cap log close
set more off
set matsize 11000
cd "N:\Eking\Prevalence_study_data"

use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"

encode adeq_sero_16, gen(ad_16)
tab rectal_HPV16 sero_16_bin if adequatepcr2==1&ad_16==1, row
tab external_HPV16 sero_16_bin if adequatepcr3==1&ad_16==1, row
tab genital_HPV16 sero_16_bin if (adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)&ad_16==1, row

tab rectal_HPV18 sero_16_bin if adequatepcr2==1&ad_16==1, row
tab external_HPV18 sero_16_bin if adequatepcr3==1&ad_16==1, row
tab genital_HPV18 sero_16_bin if (adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)&ad_16==1, row


tab rectal_HPV16 sero_18_bin if adequatepcr2==1&ad_16==1, row
tab external_HPV16 sero_18_bin if adequatepcr3==1&ad_16==1, row
tab genital_HPV16 sero_18_bin if (adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)&ad_16==1, row

tab rectal_HPV18 sero_18_bin if adequatepcr2==1&ad_16==1, row
tab external_HPV18 sero_18_bin if adequatepcr3==1&ad_16==1, row
tab genital_HPV18 sero_18_bin if (adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)&ad_16==1, row












*levels of coding doesn't work below if binary are coded as 0 and 1 so need to change to 1 and 2
local vars rectal_HPV16 rectal_HPV18 external_HPV16 external_HPV18 genital_HPV16 genital_HPV18
foreach b in `vars'{
recode `b' 1=2 
recode `b' 0=1
}			

local rectal rectal_HPV16 rectal_HPV18
local dependent sero_16_bin sero_18_bin 

putexcel A1=("risk factor")  B1=("level") C1=("OR") D1=("95%CI") E1=("aOR") F1=("a95%CI") using sero_rectal, replace
	
local row = 2
	foreach y of varlist `dependent'{
		foreach i of varlist `rectal'{
		
		
		
		
				levelsof `i', local(levels)
				
				 quietly logistic `y' i.`i' if adequatepcr2==1&ad_16==1
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
										
						quietly logistic `y' i.`i' i.gp_nummen_life age if adequatepcr2==1&ad_16==1
				matrix ab=r(table)
				
					
						local aOR=ab[1,`l']
						local aOR : display %9.2f `aOR'

						local alc=ab[5,`l']
						local alc : display %3.2f  `alc'

						local auc=ab[6,`l']
						local auc : display %3.2f  `auc'
						
						
						
						
						
				
				putexcel A`row'=("`i'") B`row'=(`l') C`row'=(`OR') D`row'=("(`lc'-`uc')")  E`row'=(`aOR') F`row'=("(`alc'-`auc')") using sero_rectal, modify
				loc row = `row' + 1
						}
						}
					loc row = `row' + 1
					putexcel A`row'=("`y'") using sero_rectal, modify
					
						}
						
						
local external external_HPV16 external_HPV18
local dependent sero_16_bin sero_18_bin 

putexcel A1=("risk factor")  B1=("level") C1=("OR") D1=("95%CI") E1=("aOR") F1=("a95%CI") using sero_external, replace
	
local row = 2
	foreach y of varlist `dependent'{
		foreach i of varlist `external'{
		
		
		
		
				levelsof `i', local(levels)
				
				 quietly logistic `y' i.`i' if adequatepcr3==1&ad_16==1
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
										
						quietly logistic `y' i.`i' i.gp_nummen_life age if adequatepcr3==1&ad_16==1
				matrix ab=r(table)
				
					
						local aOR=ab[1,`l']
						local aOR : display %9.2f `aOR'

						local alc=ab[5,`l']
						local alc : display %3.2f  `alc'

						local auc=ab[6,`l']
						local auc : display %3.2f  `auc'
						
						
						
						
						
				
				putexcel A`row'=("`i'") B`row'=(`l') C`row'=(`OR') D`row'=("(`lc'-`uc')")  E`row'=(`aOR') F`row'=("(`alc'-`auc')") using sero_external, modify
				loc row = `row' + 1
						}
						}
					loc row = `row' + 1
					putexcel A`row'=("`y'") using sero_external, modify
					
						}
						
local genital1 genital_HPV16 genital_HPV18
local dependent sero_16_bin sero_18_bin 

putexcel A1=("risk factor")  B1=("level") C1=("OR") D1=("95%CI") E1=("aOR") F1=("a95%CI") using sero_genital1, replace
	
local row = 2
	foreach y of varlist `dependent'{
		foreach i of varlist `genital1'{
		
		
		
		
				levelsof `i', local(levels)
				
				 quietly logistic `y' i.`i' if (adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)&ad_16==1
				matrix b=r(table)
				
					foreach l of local levels {
						local OR=b[1,`l']
						local OR : display %9.2f `OR'

						local lc=b[5,`l']
						local lc : display %3.2f  `lc'

						local uc=b[6,`l']
						local uc : display %3.2f  `uc'
						
										
						quietly logistic `y' i.`i' i.gp_nummen_life age if (adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)&ad_16==1
				matrix ab=r(table)
				
					
						local aOR=ab[1,`l']
						local aOR : display %9.2f `aOR'

						local alc=ab[5,`l']
						local alc : display %3.2f  `alc'

						local auc=ab[6,`l']
						local auc : display %3.2f  `auc'
						
						
						
						
						
				
				putexcel A`row'=("`i'") B`row'=(`l') C`row'=(`OR') D`row'=("(`lc'-`uc')")  E`row'=(`aOR') F`row'=("(`alc'-`auc')") using sero_genital1, modify
				loc row = `row' + 1
						}
						}
					loc row = `row' + 1
					putexcel A`row'=("`y'") using sero_genital1 , modify
					
						}
