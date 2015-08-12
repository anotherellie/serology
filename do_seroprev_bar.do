clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1
keep id agegp2 sero_16_bin sero_18_bin hiv age gp_nummen_life sero_16_cont sero_18_cont
gen sero_16_18_bin=.
replace sero_16_18_bin=1 if sero_18_bin==1|sero_16_bin==1
replace sero_16_18_bin=0 if sero_18_bin==0&sero_16_bin==0

lab define h 0 "HIV negative" 1 "HIV positive"
lab values hiv h

gen sero_16and18_bin=.
replace sero_16and18_bin=1 if sero_18_bin==1&sero_16_bin==1
replace sero_16and18_bin=0 if sero_18_bin==0|sero_16_bin==0


rename sero_16_bin sero_1
rename sero_18_bin sero_2
rename sero_16_18_bin sero_3
rename sero_16and18_bin sero_4

reshape long sero_, i(id) j(HPV)
lab define HPVgp 1 "HPV16" 2 "HPV18" 3 "HPV16 OR HPV18" 4 "HPV16 AND HPV18"
lab values HPV HPVgp

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

by hiv HPV agehpv, sort: egen mean = mean(100*sero_)

*FOR TABLE IN APPENDIX

*for each HPVgp and agegp, store confidence limits into vairables for upper and lower limits and save in excel file for table in appendix

	*calculates Clopper-Pearson (exact) confidence intervals for binomial even though I have usually used logit transformation. Need to check these do not differ from tables
ci sero_ if HPV==1 & agegp2==1 & hiv==0, binomial 
gen hisero_=r(ub)*100 if HPV==1 & agegp2==1 & hiv==0
gen lowsero_=r(lb)*100 if HPV==1 & agegp2==1 & hiv==0

*FOR TABLE IN APPENDIX

putexcel A1=("HIV") B1=("HPVgp") C1=("Age") D1=("Prevalence") E1=("Lower limit") F1=("Upper limit") using sero_hiv_age, replace 

*for each HPVgp and agegp, store confidence limits into vairables for upper and lower limits and save in excel file for table in appendix
gen lowergp=.
gen uppergp=.
gen prevgp=.
loc row = 2 
forval j=0/1{	
	forval i=1/4{
		forval k=1/5{
		
		ci sero_ if HPV==`i'&agegp2==`k' & hiv==`j', binomial
				local g`i': label HPVgp `i'
				local h`k': label agegp2 `k'
				local b`j': label hiv `j'
				
				local prev = r(mean)*100
				local prev : display %9.1f `prev'
				
				local lower = r(lb)*100
				local lower : display %9.1f `lower'
		
				local upper = r(ub)*100
				local upper : display %9.1f `upper'
		
		replace lower=`lower' if HPV==`i'&agegp2==`k' & hiv==`j'
		replace upper=`upper' if HPV==`i'&agegp2==`k' & hiv==`j'
		replace upper=`prev' if HPV==`i'&agegp2==`k' & hiv==`j'
		
				putexcel A`row' = ("`b`j''") B`row' = ("`g`i''") C`row' = ("`h`k''") D`row' = (`prev') E`row' = (`lower') F`row' = (`upper') using sero_hiv_age, modify
				loc row = `row' + 1
		replace hisero_=r(ub)*100 if HPV==`i'&agegp2==`k' & hiv==`j'
		replace lowsero_=r(lb)*100 if HPV==`i'&agegp2==`k' & hiv==`j'
		}
		loc row = `row' + 1
	}
}
	
*SAME BUT FOR EVERY YEAR OF AGE
gen lower=.
gen upper=.
gen prev=.
forval j=0/1{	
	forval i=1/4{
		forval k=16/40{
		
		ci sero_ if HPV==`i'&age==`k' & hiv==`j', binomial
				local g`i': label HPVgp `i'
				local h`k': label age `k'
				local b`j': label hiv `j'
				
				local prev = r(mean)*100
				local prev : display %9.1f `prev'
				
				local lower = r(lb)*100
				local lower : display %9.1f `lower'
		
				local upper = r(ub)*100
				local upper : display %9.1f `upper'
		
		replace lower=`lower' if HPV==`i'&age==`k' & hiv==`j'
		replace upper=`upper' if HPV==`i'&age==`k' & hiv==`j'
		replace prev=`prev' if HPV==`i'&age==`k' & hiv==`j'
		
				putexcel A`row' = ("`b`j''") B`row' = ("`g`i''") C`row' = ("`h`k''") D`row' = (`prev') E`row' = (`lower') F`row' = (`upper') using sero_hiv_age, modify
				loc row = `row' + 1
		replace hisero_=r(ub)*100 if HPV==`i'&agegp2==`k' & hiv==`j'
		replace lowsero_=r(lb)*100 if HPV==`i'&agegp2==`k' & hiv==`j'
		}
		loc row = `row' + 1
	}
}


*black and white scheme 's2mono' default is colour
#delimit ;
set scheme s2mono
;
twoway (bar mean hiv if hiv==0 , color(gs13) )
 (bar mean hiv if hiv==1)
(rcap hisero_ lowsero_ hiv , lcolor(black))

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


*black and white scheme 's2mono' default is colour
#delimit ;
set scheme s2color
;
twoway (bar mean agehpv if agegp==1)
(bar mean agehpv if agegp==2)
(bar mean agehpv if agegp==3)
(bar mean agehpv if agegp==4)
(bar mean agehpv if agegp==5)
,
legend( order(1 "18-20" 2 "21-25" 3 "26-30" 4 "31-35" 5 "36-40") subtitle("age (years)") rows(1) size(small))
by(hiv, note("") noixtitle)
graphregion(color(gs16))
xlabel( 2.5 "HPV16" 12.5 "HPV18" 22.5 `""HPV16 or""HPV18""' 32.5 `""HPV16 and""HPV18""', labsize(vsmall) noticks)
ylab(0(10)90, nogrid)
ytitle("%")
xtitle("")
;
# delimit cr
******************
*AGE

by age HPV hiv, sort: egen meanage = mean(100*sero_)
by age HPV , sort: egen meanage2 = mean(100*sero_)

twoway scatter meanage2 age, by(HPV, note("") title("total") ) xtitle("age (years)") ylab(, nogrid) ytitle("(%)")
 
preserve
drop if HPV==3|HPV==4

#delimit ;
twoway (scatter prev age if hiv==0, mcolor(ltblue))
(rcap lower upper age if hiv==0, lcolor (ltblue)),by(HPV, note("") title("HIV negative") legend(off) ) xtitle("") ylab(, nogrid) ytitle("(%)") yscale(range(0 100)) xscale(range(18 40))
; 
graph save sero_age_neg.gph, replace 
;
twoway (scatter prev age if hiv==1, mcolor(gray))
(rcap lower upper age if hiv==1, lcolor (gray)),by(HPV, note("") title("HIV positive") legend(off)) xtitle("") ylab(, nogrid) ytitle("(%)") yscale(range(0 100)) xscale(range(18 40))
;
graph save sero_age_pos.gph, replace
;
graph combine sero_age_neg.gph sero_age_pos.gph, rows(2) title("Prevalence of detectable antibodies to HPV")
;
logistic sero_ age if HPV==16&hiv==0 
logistic sero_ age if HPV==16&hiv==1 
logistic sero_ age if HPV==18&hiv==0 
logistic sero_ age if HPV==18&hiv==1


statsby upper=r(ub) lower=r(lb), clear  by(age HPV): ci sero_, binomial

by age HPV , sort: ci sero_, binomial
by age HPV , sort: ci sero_, binomial

