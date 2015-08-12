clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
*NUMber of adequate samples

encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
count if ad_16==1
count if ad_18==1
count if ad_16==1|ad_18==1

count if ad_16==1&(adequatepcr2==1|adequatepcr3==1|adequatepcr4==1)

keep if ad_16==1|ad_18==1
keep id agegp2 sero_16_bin sero_18_bin hiv age gp_nummen_life sero_16_cont sero_18_cont sero_16_18_bin sero_16and18_bin  sero_16or18_bin

*NEXT BIT NOW SAVED IN ALL_3
/*
gen sero_16_18_bin=.
replace sero_16_18_bin=1 if sero_18_bin==1|sero_16_bin==1
replace sero_16_18_bin=0 if sero_18_bin==0&sero_16_bin==0

gen sero_16and18_bin=.
replace sero_16and18_bin=1 if sero_18_bin==1&sero_16_bin==1
replace sero_16and18_bin=0 if sero_18_bin==0|sero_16_bin==0

gen sero_16or18_bin=.
replace sero_16or18_bin=1 if sero_18_bin==1|sero_16_bin==1
replace sero_16or18_bin=0 if (sero_18_bin==0&sero_16_bin==0)|(sero_18_bin==1&sero_16_bin==1)

*/
lab define h 0 "HIV negative n=480" 1 "HIV positive n=26" 2 "Total n=506" 
lab values hiv h



****************************************
*TABLE FOR THESIS CH
****************************************
*need to append an HIV group of 2 for overall?

local sero sero_16_bin sero_18_bin sero_16_18_bin sero_16and18_bin
local hiv 0 1 
putexcel A1=("HPV") B1=("HIV") C1=("n") D1=("&") E1=("95% CI") using sero_hiv_age_thesis_tbl, replace 

*for each HPVgp and HIV group, store confidence limits into vairables for upper and lower limits and save in excel file for table in ch6
loc row = 2 
foreach j in `sero'{	
	foreach i in `hiv'{
				
		ci `j' if hiv==`i', binomial
							
				
				local prev = r(mean)*100
				local prev : display %9.1f `prev'
				
				local n = r(mean)*r(N)
				
				
				local lower = r(lb)*100
				local lower : display %3.1f  `lower'
		
				local upper = r(ub)*100
				local upper : display %3.1f  `upper'
		
				putexcel A`row' = ("`j'") B`row' = ("`i'") C`row' = (`n') D`row' = (`prev') E`row' = ("(`lower'-`upper')") F`row'=(r(N))  using sero_hiv_age_thesis_tbl, modify
				loc row = `row' + 1
		
		}
		loc row = `row' + 1
	}

putexcel A1=("HPV") B1=("HIV") C1=("n") D1=("&") E1=("95% CI") using sero_hiv_age_thesis_tbl2, replace 

*FOR TABLE IN APPENDIX
local sero sero_16_bin sero_18_bin sero_16_18_bin sero_16and18_bin

putexcel A1=("HPVgp") B1=("Age") C1=("Prevalence") D1=("95% CI")  using sero_AGE_tbl, replace 

*for each HPVgp and agegp, store confidence limits into vairables for upper and lower limits and save in excel file for table in appendix
loc row = 2 
		
	foreach j in `sero'{
		forval k=1/5{
		
		ci `j' if agegp2==`k', binomial
				
				local h`k': label agegp2 `k'
				
				local prev = r(mean)*100
				local prev : display %9.1f `prev'
				
				local lower = r(lb)*100
				local lower : display %3.1f `lower'
		
				local upper = r(ub)*100
				local upper : display %3.1f `upper'
		
				putexcel A`row' = ("`j'") B`row' = ("`h`k''") C`row' = (`prev') D`row' = ("`lower'-`upper'") using sero_AGE_tbl, modify
				loc row = `row' + 1
		
		}
		loc row = `row' + 1
	}

local hiv 0 1 
local sero sero_16_bin sero_18_bin sero_16_18_bin sero_16and18_bin

putexcel A1=("HPVgp") B1=("HIV") C1=("Age") D1=("Prevalence") E1=("95% CI")  using sero_AGEhiv_tbl, replace 
loc row = 2 
		foreach i in `hiv'{
	foreach j in `sero'{
		forval k=1/5{
		
		
		ci `j' if agegp2==`k' & hiv==`i', binomial
				
				local h`k': label agegp2 `k'
				
				local prev = r(mean)*100
				local prev : display %9.1f `prev'
				
				local lower = r(lb)*100
				local lower : display %3.1f `lower'
		
				local upper = r(ub)*100
				local upper : display %3.1f `upper'
		
				putexcel A`row' = ("`j'") B`row' = ("`i'") C`row' = ("`h`k''") D`row' = (`prev') E`row' = ("`lower'-`upper'") using sero_AGEhiv_tbl, modify
				loc row = `row' + 1
		
		}
		loc row = `row' + 1
	}
}
	
rename sero_16_bin sero_1
rename sero_18_bin sero_2
rename sero_16_18_bin sero_3
rename sero_16and18_bin sero_4





****************************************************************
***************************************************************
*HERE GETS LONG
*****************************************************************
*****************************************************************
reshape long sero_, i(id) j(HPV)
lab define HPVgp 1 "HPV16" 2 "HPV18" 3 "HPV16 and/or 18" 4 "HPV16 and HPV18"
lab values HPV HPVgp

*GIVE HIV a total category ==2 automatically for graphs.
save "N:\Eking\Prevalence_study_data\Data_files\sero.dta", replace
replace hiv=2
append using "N:\Eking\Prevalence_study_data\Data_files\sero.dta"

*combine agegp2 and HPVgp
generate agehpv = agegp2    if HPV == 1
replace  agehpv = agegp2+10  if HPV == 2
replace  agehpv = agegp2+20 if HPV == 3
replace  agehpv = agegp2+30 if HPV == 4

sort agehpv
list agehpv agegp2 sero_, sepby(HPV)

*end up with 35 gourps of agehpv becuas ethere are 1-5 11-15 21-25 31-35


***************************************************
*generate set of percent summary variables 		  *
***************************************************
*BE CAREFUL! NOW DATA IS LONG CAN IMPACT ON CIs IF DON@T HAVE THE CORRECT DENOMINATOR!
by hiv HPV agehpv, sort: egen mean = mean(100*sero_)

by hiv HPV, sort: egen mean1 = mean(100*sero_)
by HPV, sort: egen mean2 = mean(100*sero_)

summ mean2 if HPV==3
ci sero_ if HPV==3, binomial


sort hiv HPV agegp2
gen hi_sero_=.
gen low_sero_=.
forval i=1/4{
forval j=0/2{
ci sero_ if HPV==`i'&hiv==`j', binomial
replace low_sero_=100*r(lb) if HPV==`i'&hiv==`j'
replace hi_sero_=100*r(ub) if HPV==`i'&hiv==`j'
}
}

*Figure 1: overall prev by HIV status
*to get order along x axis, recode hiv
recode hiv 2=0 0=1 1=2
set scheme s2color
#delimit ;
twoway 
(bar mean1 hiv if hiv==0)
 (bar mean1 hiv if hiv==1)
 (bar mean1 hiv if hiv==2)
(rcap hi_sero_ low_sero_ hiv , lcolor(black))

,
legend( order(1 2 3)label (1 "Total n=506") label (2 "HIV negative n=480") label (3 "HIV positive n=26") rows(1) region(lstyle(none)) )
by(HPV, note("") noixtitle rows(1) noixlabel noixaxes noixtick graphregion(fcolor(white)))
graphregion(fcolor(white))
xscale(off)
ylab(0(10)90, nogrid)
ytitle("%")
xtitle("")
;
# delimit cr




*FOR TABLE IN APPENDIX

*for each HPVgp and agegp, store confidence limits into vairables for upper and lower limits and save in excel file for table in appendix

	*calculates Clopper-Pearson (exact) confidence intervals for binomial even though I have usually used logit transformation. Need to check these do not differ from tables
	ci sero_ if HPV==1, binomial 

ci sero_ if HPV==1 & agegp2==1 & hiv==0, binomial 
gen hisero_=r(ub)*100 if HPV==1 & agegp2==1 & hiv==0
gen lowsero_=r(lb)*100 if HPV==1 & agegp2==1 & hiv==0

*FOR TABLE IN APPENDIX

putexcel A1=("HIV") B1=("HPVgp") C1=("Age") D1=("Prevalence") E1=("Lower limit") F1=("n") G1=("N") using sero_hiv_age, replace 

*for each HPVgp and agegp, store confidence limits into vairables for upper and lower limits and save in excel file for table in appendix
loc row = 2 
forval j=0/2{	
	forval i=1/4{
		forval k=1/5{
		
		ci sero_ if HPV==`i'&agegp2==`k' & hiv==`j', binomial
				local g`i': label HPVgp `i'
				local h`k': label agegp2 `k'
				local b`j': label hiv `j'
				
				local prev = r(mean)*100
				local prev : display %9.1f `prev'
				
				local lower = r(lb)*100
				local lower : display %3.1f  `lower'
		
				local upper = r(ub)*100
				local upper : display %3.1f  `upper'
		
				putexcel A`row' = ("`b`j''") B`row' = ("`g`i''") C`row' = ("`h`k''") D`row' = (`prev') E`row' = ("(`lower'-`upper')") F`row'=(r(mean)*r(N)) G`row'=(r(N))  using sero_hiv_age, modify
				loc row = `row' + 1
		replace hisero_=r(ub)*100 if HPV==`i'&agegp2==`k' & hiv==`j'
		replace lowsero_=r(lb)*100 if HPV==`i'&agegp2==`k' & hiv==`j'
		}
		loc row = `row' + 1
	}
}
	

/*

*black and white scheme 's2mono' default is colour
#delimit ;
set scheme s2mono
;
twoway (bar mean hiv if hiv==0 , color(gs13) )
 (bar mean hiv if hiv==1)
(rcap hi_sero_ low_sero_ hiv , lcolor(black))

,
legend (off)
by(HPV, legend(off) note("") noixtitle)
graphregion(color(gs16))
xlabel( 0 "HIV negative" 1 "HIV positive", noticks)

ylab(0(10)90, nogrid)
ytitle("%")
xtitle("")
;
# delimit cr
*/

*black and white scheme 's2mono' default is colour
*this is now hiv-negative following an earlier recode
preserve
keep if hiv==1|hiv==0
#delimit ;
set scheme s2color
;
twoway (bar mean agehpv if agegp==1)
(bar mean agehpv if agegp==2)
(bar mean agehpv if agegp==3)
(bar mean agehpv if agegp==4)
(bar mean agehpv if agegp==5)
(rcap hisero_ lowsero_ agehpv, lcolor(black) lwidth(vthin))
,
legend( order(1 "18-20" 2 "21-25" 3 "26-30" 4 "31-35" 5 "36-40") subtitle("Age (Years)", size(vsmall)) rows(1) size(vsmall))
graphregion(color(white))
xlabel( 2.5 "HPV16" 12.5 "HPV18" 22.5 `""HPV16 or""HPV18""' 32.5 `""HPV16 &""HPV18""', labsize(vsmall) noticks)
by (hiv)
ylab(0(20)100, labsize(vsmall) nogrid)
ytitle("%")
xtitle("")
;
# delimit cr
restore
******************
*NO TOTAL GRAPH
******************
preserve
drop if hiv==2
#delimit ;
set scheme s2color
;
twoway (bar mean agehpv if agegp==1)
(bar mean agehpv if agegp==2)
(bar mean agehpv if agegp==3)
(bar mean agehpv if agegp==4)
(bar mean agehpv if agegp==5)
(rcap hisero_ lowsero_ agehpv, lcolor(black) lwidth(vthin))
,
legend( order(1 "18-20" 2 "21-25" 3 "26-30" 4 "31-35" 5 "36-40") subtitle("Age (Years)", size(vsmall)) rows(1) size(vsmall))
by(hiv, note("") noixtitle rows(1)graphregion(color(white)))
graphregion(color(white))
xlabel( 2.5 "HPV16" 12.5 "HPV18" 22.5 `""HPV16 or""HPV18""' 32.5 `""HPV16 &""HPV18""', labsize(vsmall) noticks)
ylab(0(20)100, labsize(vsmall) nogrid)
ytitle("%")
xtitle("")
;
# delimit cr
restore
******************
*ONLYTOTAL GRAPH
******************
preserve
drop if hiv==1|hiv==0
#delimit ;
set scheme s2color
;
twoway (bar mean agehpv if agegp==1)
(bar mean agehpv if agegp==2)
(bar mean agehpv if agegp==3)
(bar mean agehpv if agegp==4)
(bar mean agehpv if agegp==5)
(rcap hisero_ lowsero_ agehpv, lcolor(black) lwidth(vthin))
,
legend( order(1 "18-20" 2 "21-25" 3 "26-30" 4 "31-35" 5 "36-40") subtitle("Age (Years)", size(vsmall)) rows(1) size(vsmall))
by(hiv, note("") noixtitle rows(1)graphregion(color(white)))
graphregion(color(white))
xlabel( 2.5 "HPV16" 12.5 "HPV18" 22.5 `""HPV16 or""HPV18""' 32.5 `""HPV16 &""HPV18""', labsize(vsmall) noticks)
ylab(0(20)100, labsize(vsmall) nogrid)
ytitle("%")
xtitle("")
;
# delimit cr
restore

******************
*AGE
by age HPV hiv, sort: egen meanage = mean(100*sero_)
by age HPV , sort: egen meanage2 = mean(100*sero_)
twoway scatter meanage2 age, by(HPV, note("") title("total") ) xtitle("age (years)") ylab(, nogrid) ytitle("prevalence of detectable antibodies to HPV (%)") 
twoway scatter meanage age if hiv==0, by(HPV, note("") title("HIV negative") ) xtitle("age (years)") ylab(, nogrid) ytitle("prevalence of detectable antibodies to HPV (%)") 
twoway scatter meanage age if hiv==1, by(HPV, note("") title("HIV positive")) xtitle("age (years)" ) ylab(, nogrid) ytitle("prevalence of detectable antibodies to HPV (%)") 

logistic sero_ age if HPV==16&hiv==0 
logistic sero_ age if HPV==16&hiv==1 
logistic sero_ age if HPV==18&hiv==0 
logistic sero_ age if HPV==18&hiv==1
