clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1
keep id sero_16_bin sero_18_bin hiv age gp_nummen_life sero_16_cont sero_18_cont


****
*RESTRICT ANALYSIS TO THOSE WITH DETECTABLE ANTIBODIES



tw hist sero_16_cont if sero_16_bin==1, xscale(range(0 1500)) xlab(0(200)1500) yscale(range(0 100))title("Anti-HPV16") ylab(0(20)100, nogrid) percent color(ltblue) lcolor(ltblue) xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) ytitle("Percent") name(sero16, replace)
tw hist sero_18_cont if sero_18_bin==1, xscale(range(0 1500)) xlab(0(200)1500) yscale(range(0 100))title("Anti-HPV18") ylab(0(20)100, nogrid) percent color(navy) lcolor(navy) xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) ytitle("Percent") name(sero18, replace)
graph combine sero16 sero18, cols(1) graphregion(fcolor(white))  

tw hist sero_16_cont if sero_16_bin==1 & sero_16_cont<200, xscale(range(0 200)) xlab(20(20)200) yscale(range(0 100))title("Anti-HPV16") ylab(0(20)100, nogrid) percent color(ltblue) lcolor(ltblue) xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) ytitle("Percent") name(sero16, replace)
tw hist sero_18_cont if sero_18_bin==1 & sero_18_cont<200, xscale(range(0 20)) xlab(0(20)200) yscale(range(0 100))title("Anti-HPV18") ylab(0(20)100, nogrid) percent color(navy) lcolor(navy) xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) ytitle("Percent") name(sero18, replace)
graph combine sero16 sero18, cols(1) graphregion(fcolor(white))  


****
*categorise
gen sero_16_cat=sero_16_cont
recode sero_16_cat 0/20=1 21/30=2 31/40=3 41/50=4 51/60=5 61/70=6 71/80=7 81/90=8 91/100=9 101/200=10 201/300=11 301/max=12
#delimit ;
twoway
(hist sero_16_cat if sero_16_bin==1&sero_16_cat<10, discrete freq title("Anti-HPV16") 
color(ltblue) lcolor(white) ylab(, nogrid) xtitle("ELISA units/ml") 
xlab(1"20" 2"21-30" 3"31-40" 4"41-50" 5"51-60" 6"61-70" 7"71-80" 8"81-90" 9"91-100" 10"101-200" 11">201-300" 12">300", angle(vertical) nogrid) graphregion(fcolor(white)) legend(off) )

(hist sero_16_cat if sero_16_bin==1&sero_16_cat==10|sero_16_cat==11, discrete freq title("Anti-HPV16") 
color(navy) lcolor(white) ylab(, nogrid) xtitle("ELISA units/ml") 
xlab(1"20" 2"21-30" 3"31-40" 4"41-50" 5"51-60" 6"61-70" 7"71-80" 8"81-90" 9"91-100" 10"101-200" 11">201-300" 12">300", angle(vertical) nogrid) graphregion(fcolor(white)) legend(off))

(hist sero_16_cat if sero_16_bin==1&sero_16_cat==12, discrete freq title("Anti-HPV16") 
color(gs4) lcolor(white) ylab(, nogrid) xtitle("ELISA units/ml") 
xlab(1"20" 2"21-30" 3"31-40" 4"41-50" 5"51-60" 6"61-70" 7"71-80" 8"81-90" 9"91-100" 10"101-200" 11">201-300" 12">300", angle(vertical) nogrid) graphregion(fcolor(white)) legend(off)),
name(cat16, replace) title("Anti-HPV16")
;
gen sero_18_cat=sero_18_cont
;
recode sero_18_cat 0/20=1 21/30=2 31/40=3 41/50=4 51/60=5 61/70=6 71/80=7 81/90=8 91/100=9 101/200=10 201/300=11 301/max=12
;
#delimit ;
twoway
(hist sero_18_cat if sero_18_bin==1&sero_18_cat<10, discrete freq 
color(ltblue) lcolor(white) ylab(, nogrid) xtitle("ELISA units/ml") 
xlab(1"20" 2"21-30" 3"31-40" 4"41-50" 5"51-60" 6"61-70" 7"71-80" 8"81-90" 9"91-100" 10"101-200" 11">201-300" 12">300", angle(vertical) nogrid) graphregion(fcolor(white)) legend(off) )

(hist sero_18_cat if sero_18_bin==1&sero_18_cat==10|sero_18_cat==11, discrete freq 
color(navy) lcolor(white) ylab(, nogrid) xtitle("ELISA units/ml") 
xlab(1"20" 2"21-30" 3"31-40" 4"41-50" 5"51-60" 6"61-70" 7"71-80" 8"81-90" 9"91-100" 10"101-200" 11">201-300" 12">300", angle(vertical) nogrid) graphregion(fcolor(white)) legend(off))

(hist sero_18_cat if sero_18_bin==1&sero_18_cat==12, discrete freq 
color(gs4) lcolor(white) ylab(, nogrid) xtitle("ELISA units/ml") 
xlab(1"20" 2"21-30" 3"31-40" 4"41-50" 5"51-60" 6"61-70" 7"71-80" 8"81-90" 9"91-100" 10"101-200" 11">201-300" 12">300", angle(vertical) nogrid) graphregion(fcolor(white)) legend(off)),
name(cat18, replace) title("Anti-HPV18")
;
graph combine cat16 cat18, cols(1) graphregion(fcolor(white))
 
*normal approx
ci sero_16_cont
regress sero_16_cont age
predict fit
twoway (scatter sero_16_cont age) (lfit sero_16_cont age), name(elisa16_age, replace)

restore
preserve
keep if sero_18_bin==1

regress sero_18_cont age
predict fit
twoway (scatter sero_18_cont age) (lfit sero_18_cont age) , name(elisa18_age, replace)
restore

graph combine elisa16_age elisa18_age


*LIKELIHOOD OF ACCEPTING VACCINE
*Probable vacc-induced= at least one high or both moderate
*probably natural= one neg one pos
*possible natural or vaccine= both low or low/moderate
gen sero_16_underlb=0
gen sero_16_overub=0
gen sero_16_in95CI=0
gen sero_18_underlb=0
gen sero_18_overub=0
gen sero_18_in95CI=0
*binary variable for where estimate lies in the normal distribution
*normal approx
ci sero_16_cont if sero_16_bin==1
replace sero_16_underlb=1 if sero_16_cont<r(lb)
replace sero_16_overub=1 if sero_16_cont>r(ub)
replace sero_16_in95CI=1 if sero_16_cont<r(ub)& sero_16_cont>r(lb)



*binary variable for where estimate lies in the normal distribution

*normal approx
ci sero_18_cont if sero_18_bin==1
replace sero_18_underlb=1 if sero_18_cont<r(lb)
replace sero_18_overub=1 if sero_18_cont>r(ub)
replace sero_18_in95CI=1 if sero_18_cont<r(ub)& sero_16_cont>r(lb)


*********************
*GRADING EU/ml
*high=>95% of those positive for single antibody
*low=<95% of those positive for both HPV types
*moderate= in 95%CI

*************************

*categorical antibody concentration 1=low, 2=moderate, 3=high
gen sero_cat=.
replace sero_cat=1 if (sero_16_bin==1 & sero_18_bin==1)& (sero_16_underlb==1&sero_18_underlb==1)
replace sero_cat=2 if sero_16_in95CI==1|sero_18_in95CI==1
replace sero_cat=3 if (sero_16_bin==1 & sero_18_bin==0 & sero_16_overub==1)|(sero_16_bin==0 & sero_18_bin==1 & sero_18_overub==1)




lab define cat 1 "low" 2 "moderate" 3"high"
lab values sero_cat cat

*THIS CLASSIFICATION DOESNT SEEM RIGHT SO GOING WITH the one below instead
/*
gen sero_prob_vacc=.
gen sero_prob_nat=.
gen sero_poss_natorvacc=.

*make sure only missing if negative for serology
replace sero_prob_vacc=0 if sero_16_bin==1|sero_18_bin==1
*double Ab pos and 1high or 2 moderate
replace sero_prob_vacc=1 if (sero_16_bin==1& sero_18_bin==1) & (sero_cat==3)|(sero_16_in95CI==1&sero_18_in95CI==1)

*make sure only missing if negative for serology
replace sero_prob_nat=0 if sero_16_bin==1|sero_18_bin==1
*Single Ab
replace sero_prob_nat=1 if (sero_16_bin==1 & sero_18_bin==0)|(sero_16_bin==0 & sero_18_bin==1)

*make sure only missing if negative for serology
replace sero_poss_natorvacc=0 if sero_16_bin==1|sero_18_bin==1
*double Ab+ve and both low or 1 low 1 moderate
replace sero_poss_natorvacc=1 if (sero_16_bin==1 & sero_18_bin==0)|(sero_16_bin==0 & sero_18_bin==1)
*/

gen sero_prob_vacc=.
gen sero_prob_nat=.
gen sero_poss_natorvacc=.

replace sero_prob_vacc=0 if sero_16_bin==1|sero_18_bin==1
*double Ab pos and 1high or 2 moderate
replace sero_prob_vacc=1 if (sero_16_bin==1& sero_18_bin==1) & (sero_16_overub==1|sero_18_overub==1)|(sero_16_in95CI==1&sero_18_in95CI==1)

*make sure only missing if negative for serology
replace sero_prob_nat=0 if sero_16_bin==1|sero_18_bin==1
*Single Ab
replace sero_prob_nat=1 if (sero_16_bin==1 & sero_18_bin==0)|(sero_16_bin==0 & sero_18_bin==1)

*make sure only missing if negative for serology
replace sero_poss_natorvacc=0 if sero_16_bin==1|sero_18_bin==1
*double Ab+ve and both low or 1 low 1 moderate
replace sero_poss_natorvacc=1 if (sero_16_underlb==1&sero_18_underlb==1)|(sero_16_in95CI==1&sero_18_underlb==1)|(sero_18_in95CI==1&sero_16_underlb==1)


