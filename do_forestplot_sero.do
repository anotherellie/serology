** LAST UPDATED: 04FEB14, AUTHOR: PHIL P UPDATED BY: ELLIE
* FILE: chart - forest plots.do **

* File objective: To create the chart for the determinants of various groupings of HPV 
//This file is based on data stored within forest_plot_data_xxYYYXX which needs to be pasted into data editor

* IMPORTANT NOTE: This dofile was originally created to look at how different 
*	education levels are associated with sexual outcomes in different NATSAL 
*	surveys. Therefore alot of this code still refer to survey and education.




* RISK FACTORS DATASET/EXPLANATORY VARS
*============================
* Clear dataset to add excel output in to stata
cap log close
clear
cd "N:\Eking\Prevalence_study_data"

set more off
log using "N:\Eking\Prevalence_study_data\Log_files\forest_plot.log", replace
import excel using "N:\Eking\Prevalence_study_data\forestsero.xlsx", firstrow


encode exp, gen (exp1)
encode sero, gen(sero1)

* Rename value labels
/*------------------------
 tab exp


exp	Freq.	Percent	Cum.
			
1 anl_drug	
2 gp_anlptnrs_lstyr2	
3 gp_anlptnrs_nocdm_lstyr2	
4 gp_new_anlptnrs_lstyr2	
5 gp_nummen_life	
6 hiv	0
7 lst_anl_wmn3	
8 lst_ins_anl3	
9 lst_rec_anl3	
10 position	



. tab exp, nolab

        exp |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |          4        9.52        9.52
          2 |          6       14.29       23.81
          3 |          4        9.52       33.33
          4 |          4        9.52       42.86
          5 |          4        9.52       52.38
          6 |          4        9.52       61.90
          7 |          4        9.52       71.43
          8 |          4        9.52       80.95
          9 |          4        9.52       90.48
         10 |          4        9.52      100.00
------------+-----------------------------------
      Total |         42      100.00


*/

lab drop exp1

*TO get order down y axis as wanted: Age, HIV, educ2, lifetime partners, partners lst yr, receptive anal, ins_anl, lst_os_man, age_os_man, age_rec_anl, concur2,position13, anl_drug stillsex
recode exp1 8=1 3=2 7=3 4=4 6=5 5=6 11=7 9=8 10=9 2=10 12=11 1=12 

sort sero1 adjusted exp1 level_exp
by sero1 adjusted: gen exp4=_n 
*TWO aprroaches
*a) scatter by site and have y axis as all vars in which case need to seaparate exp4 for every unit increase in exp
local x=1
gen exp5=exp4
forval i=1/14{
replace exp5=exp5+`x' if exp1==`i'
local x=`x'+2
}
sort sero1 adjusted exp1 level_exp exp4


#delimit ;
lab define exp5


1"HIV status"
2"Negative"
3"Positive"

5"Years of education since age 16"
6"Up to 2"
7"More than 2"

9"Lifetime oral/anal sex partners (n)"
10"<31"
11">=31"

13"Male sex partners-last year (n)"
14"<10"
15">=10"

17"New partners-last year (n)"
18"<10"
19">=10"

21"Condomless partners-last year (n)"
22"<10"
23">=10"

25"Receptive anal sex-last 3 months"
26"No"
27"Yes"

29"Insertive anal sex (man)-last 3 months"
30"No"
31"Yes"

33"Oral sex (man)-last 3 months"
34"No"
35"Yes"

37 "Overlapping within 3 most recent partnerships"
38 "No"
39 "Yes"

41 "Positioning during condomless sex-last year"
42 "Insertive only"
43 "Receptive/versatile"

45 "Use of drugs in anus ever"
46 "No"
47 "Yes"

49 "Most recent relationship continuing"
50 "No"
51 "Yes"
;
#delimit cr	

lab values exp5 exp5
replace exp5=exp5-0.1 if level_exp==1

replace exp5=exp5+0.5 if sero1==2



* CHART CODE
*==================
keep if adjusted =="aOR"

#delimit ;
twoway (scatter exp5 or_est if level_exp==1&sero1==1, mcolor(black) msize(small) msymbol(circle_hollow) mlwidth(thin)) 
(scatter exp5 or_est if level_exp==2&sero1==1, mcolor(teal) msize(small) msymbol(circle) mlwidth(thin))
 
(scatter exp5 or_est if level_exp==2&sero1==2, mcolor(cranberry) msize(small) msymbol(circle) mlwidth(thin))



	(rcap lci uci exp5 if sero1==1, lcolor(teal) lwidth(vthin) msize(small) horizontal)
	(rcap lci uci exp5 if sero1==2, lcolor(cranberry) lwidth(vthin) msize(small) horizontal)

	

		,
	
xsize(6) ysize(11)
	xlabel(0.25 "0.25"  1 "1" 2 "2" 4 "4" 10 "10" 20 "20", labsize(vsmall)) xline(1, lwidth(thin) lcolor(gs11)) 
	xtitle("Age-adjusted odds ratio", size(vsmall) margin(medsmall))
	yscale(reverse ) xscale(log)
	ylabel(1 2 3 5 6 7 9 10 11 13 14 15 17 18 19 21 22 23 25 26 27 29 30 31 33 34 35 37 38 39 41 42 43 45 46 47 49 50 51, nogrid labsize(vsmall) angle(0) valuelabel tlength(zero)) 
	ytitle(" ")
	subtitle(, size(medsmall) nobox) 
	legend(order(1 2 3) label(1 "Reference") label(2 "anti-HPV16") label(3 "anti-HPV18") size(vsmall) nobox region(lstyle(none)) rows(1) span)
	graphregion(margin(large) fcolor(white) lcolor(none))
		
	;






#delimit ;
twoway (scatter exp5 or_est if level_exp==1&sero1==1, mcolor(black) msize(small) msymbol(circle_hollow) mlwidth(thin)) 
(scatter exp5 or_est if level_exp==2&sero1==1, mcolor(teal) msize(small) msymbol(circle) mlwidth(thin))
 
(scatter exp5 or_est if level_exp==2&sero1==2, mcolor(cranberry) msize(small) msymbol(circle) mlwidth(thin))



	(rcap lci uci exp5 if sero1==1, lcolor(teal) lwidth(vthin) msize(small) horizontal)
	(rcap lci uci exp5 if sero1==2, lcolor(cranberry) lwidth(vthin) msize(small) horizontal)

	

		,
	
xsize(6) ysize(8.5)
	xlabel(0.25 "0.25"  1 "1" 2 "2" 4 "4" 10 "10" 20 "20", labsize(vsmall)) xline(1, lwidth(thin) lcolor(gs11)) 
	xtitle("Age-adjusted odds ratio", size(vsmall) margin(medsmall))
	yscale(reverse ) xscale(log)
	ylabel(1 2 3 5 6 7 9 10 11 13 14 15 17 18 19 21 22 23 25 26 27 29 30 31 33 34 35 37 38 39 41 42 43 45 46 47 49 50 51, nogrid labsize(vsmall) angle(0) valuelabel tlength(zero)) 
	ytitle(" ")
	subtitle(, size(medsmall) nobox) 
	legend(order(1 2 3) label(1 "Reference") label(2 "anti-HPV16") label(3 "anti-HPV18") size(vsmall) nobox region(lstyle(none)) lwidth(none) lcolor(white) rows(1) span)
	graphregion(margin(zero) color(white) )

		
	;

































