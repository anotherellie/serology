clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1

*16 OR 18
gen sero_16_18_bin=.
replace sero_16_18_bin=1 if sero_18_bin==1|sero_16_bin==1
replace sero_16_18_bin=0 if sero_18_bin==0&sero_16_bin==0

*16 AND 18
gen sero_16and18_bin=.
replace sero_16and18_bin=1 if sero_18_bin==1&sero_16_bin==1
replace sero_16and18_bin=0 if sero_18_bin==0|sero_16_bin==0

*Develop outcome variables for concordance
*genital_concordance. Are there any HPV types in common between anal/external or urine/anal or external anal? If yes, then coded as 1
gen genital_concord=0

local type HPV16 HPV18  
	foreach t in `type'{
			gen concord_`t'=0
				}
	
	
	foreach t in `type'{
			recode concord_`t' 0=1 if (rectal_`t'==1 &external_`t'==1)| (rectal_`t'==1 & urine_`t'==1)| (urine_`t'==1 & external_`t'==1)
			replace concord_`t'=. if adequatepcr2!=1|adequatepcr3!=1|adequatepcr4!=1
			}
*concordance versus insgle type infection. 1=conrdant 0=single gential infection .=no HR infection
			
	foreach t in `type'{
			gen concord2_`t'=.
				}
	
	
	foreach t in `type'{
			replace concord2_`t'=1 if (rectal_`t'==1 &external_`t'==1)| (rectal_`t'==1 & urine_`t'==1)| (urine_`t'==1 & external_`t'==1)
			replace concord2_`t'=0 if (rectal_`t'==1 &external_`t'!=1 & urine_`t'!=1)| (urine_`t'==1 & external_`t'!=1 & rectal_`t'!=1)| (external_`t'==1 & rectal_`t'!=1 & urine_`t'!=1)
			}
			
*16/18
	*single infectioncomparison
	gen concord2_HPV16_18=.
	replace concord2_HPV16_18=1 if concord2_HPV16==1|concord2_HPV18==1
	replace concord2_HPV16_18=0 if (concord2_HPV16==1&concord2_HPV18==0)|(concord2_HPV16==0&concord2_HPV18==1)

		*compared to not concordance (single and negatvie)
	gen concord_HPV16_18=.
	replace concord_HPV16_18=1 if concord_HPV16==1|concord_HPV18==1
	replace concord_HPV16_18=0 if (concord_HPV16==1&concord_HPV18==0)|(concord_HPV16==0&concord_HPV18==1)|(concord_HPV16==0&concord_HPV18==0)
	
*16/18/31/33/35/39/45/51/52/56/58/59/68 are considered HR-HPV types, HPV genotypes 6/11 are considered low risk HPV (LR-HPV) types while HPV genotypes 26/53/66/70/73/82 
local hrtype  HPV16 HPV18 HPV31 HPV33 HPV35 HPV39 HPV45 HPV51 HPV52 HPV56 HPV58 HPV59 HPV68  
	gen concord2_HRtypes=0
	foreach k in `hrtype'{
	replace concord2_HRtypes=1 if concord2_`k'==1
		}
	replace concord2_HRtypes=. if (adequatepcr2!=1|adequatepcr3!=1|adequatepcr4!=1)|(rectal_HRtypes!=1 & external_HRtypes!=1 & urine_HRtypes!=1)
	
		gen concord_HRtypes=0
		foreach k in `hrtype'{
	replace concord_HRtypes=1 if concord_`k'==1
	}
	replace concord_HRtypes=. if (adequatepcr2==1&adequatepcr3==1)|(adequatepcr2==1&adequatepcr4==1)|(adequatepcr3==1&adequatepcr4==1)

	gen concord_HPVup=0
		foreach k in `type'{
	replace concord_HPVup=1 if concord_`k'==1
	}
	replace concord_HRtypes=. if adequatepcr2!=1|adequatepcr3!=1|adequatepcr4!=1
	



*levels of coding doesn't work below if binary are coded as 0 and 1 so need to change to 1 and 2
local bin hiv genital_HPV16 genital_HPV18 genital_HPV16_18 genital_HRtypes concord_HPV16 concord_HPV18 concord_HPV16_18 concord_HRtypes concord2_HPV16 concord2_HPV18 concord2_HPV16_18 concord2_HRtypes
foreach b in `bin'{
recode `b' 1=2 
recode `b' 0=1
}

********************
*TABLE of numbers and OR and CIs adjussted for age, hiv gp-Nummne_life

local categ genital_HPV16 genital_HPV18 genital_HPV16_18 concord_HPV16 concord_HPV18 concord_HPV16_18 concord2_HPV16 concord2_HPV18 concord2_HPV16_18
local sero sero_16_bin sero_18_bin sero_16_18_bin sero_16and18_bin

putexcel A1=("risk factor")  B1=("level") C1=("N") D1=("n") E1=("OR") F1=("95% CI") G1=("p-testparm") using sero_concord, replace
	
local row = 2
	foreach y of varlist `sero'{
		foreach i of varlist `categ'{
				levelsof `i', local(levels)
				
				 quietly logistic `y' i.`i' age i.hiv i.gp_nummen_life
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
				
				ci `y' if `i'==`l', binomial
				
				
				putexcel A`row'=("`i'") B`row'=(`l') C`row'=(r(N)) D`row'=(r(mean)*r(N))  E`row'=(`OR') F`row'=("(`lc'-`uc')")  G`row'=(`p') using sero_concord, modify
				loc row = `row' + 1
						}
						}
						}
*TEST HPV viral load and concordance
