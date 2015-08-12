clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1
keep id sero_16_bin sero_18_bin hiv age gp_nummen_life sero_16_cont sero_18_cont agegp2


****
*RESTRICT ANALYSIS TO THOSE WITH DETECTABLE ANTIBODIES
*BOXPLOTS
graph box sero_16_cont if sero_16_bin==1, name(sero16, replace) graphregion(fcolor(white)) box(1, color(navy)) ylab(0(200)1500,nogrid) yscale(range(0 1500)) ytitle("ELISA units/ml") title("Anti-HPV16")
graph box sero_18_cont if sero_18_bin==1, name(sero18, replace) graphregion(fcolor(white)) box(1, color(maroon)) ylab(0(200)1500,nogrid) yscale(range(0 1500)) ytitle("") title("Anti-HPV18")
graph combine sero16 sero18, rows(1) graphregion(fcolor(white)) name(a, replace)  

graph box sero_16_cont if sero_16_bin==1, noout name(sero16a, replace) box(1, color(navy)) graphregion(fcolor(white)) ylab(0(20)240,nogrid) yscale(range(0 240)) ytitle("ELISA units/ml") title("Anti-HPV16") note("")
graph box sero_18_cont if sero_18_bin==1, noout name(sero18a, replace) box(1, color(maroon)) graphregion(fcolor(white)) ylab(0(20)240,nogrid) yscale(range(0 240)) ytitle("") title("Anti-HPV18") note("")
graph combine sero16a sero18a, rows(1) graphregion(fcolor(white))  name(b, replace)

graph combine a b, cols(1)

***TRANSFORM DATA AFTER GLADDER
gladder sero_16_cont if sero_16_bin==1

gen sero_sqrt_16=1/sqrt(sero_16_cont)
replace sero_sqrt_16=. if sero_16_bin==0
hist sero_sqrt_16

gen sero_log_16=log(sero_16_cont)
replace sero_log_16=. if sero_16_bin==0
hist sero_log_16, normal color(navy) graphregion(fcolor(white)) yscale(range(0 0.8)) ylab(0(0.1)0.8, nogrid) xscale(range(1 8)) xlab(1(1)8,  nolab) subtitle ("b", position(11) ) xtitle("") name(log16, replace)

gen sero_log_18=log(sero_18_cont)
replace sero_log_18=. if sero_18_bin==0
hist sero_log_18, normal color(maroon) graphregion(fcolor(white)) yscale(range(0 0.8)) ylab(0(0.1)0.8, nogrid) xscale(range(1 8)) xlab(1(1)8) xtitle("log ELISA units/ml") name(log18, replace)

tw hist sero_18_cont if sero_18_bin==1, xscale(range(0 1500)) xlab(0(200)1500) yscale(range(0 0.012)) ylab(0(0.004)0.012, nogrid)  color(maroon)  xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) name(sero18, replace)

tw hist sero_16_cont if sero_16_bin==1, xscale(range(0 1500)) xlab(0(200)1500, nolab) subtitle("a", position(11) ) yscale(range(0 0.012)) ylab(0(0.004)0.012, nogrid)  color(navy) xtitle("") legend(off) graphregion(fcolor(white)) name(sero16, replace)

graph combine sero16 log16, rows(1) graphregion(fcolor(white)) title("Anti-HPV16") name(top, replace)
graph combine sero18 log18, rows(1) graphregion(fcolor(white)) title("Anti-HPV18") name(bottom, replace)
graph combine top bottom, cols(1) graphregion(fcolor(white)) 

*normal approx
*TRANSOFRMED REGRESSIONS
regress sero_sqrt_16 age if sero_16_bin==1
predict fit
predict r
twoway (scatter sero_sqrt_16 age) (lfitci sero_sqrt_16 age), name(elisa16_age, replace)
drop fit
drop r
regress sero_log_16 age if sero_16_bin==1
predict fit
predict r
hist r, normal

twoway (scatter sero_log_16 age) (lfitci sero_log_16 age), title("Anti-HPV16")legend (label(1 "Observed data") label(3 "Fitted values") label(2 "95% CI")) graphregion(fcolor(white)) ytitle("log ELISA units/ml") xtitle("Age (Years)") name(log16_age, replace)


drop fit
drop r
regress sero_log_18 age if sero_18_bin==1
predict fit
predict r
hist r, normal

twoway (scatter sero_log_18 age) (lfitci sero_log_18 age), title("Anti-HPV18") legend (label(1 "Observed data") label(3 "Fitted values") label(2 "95% CI")) graphregion(fcolor(white)) ytitle("log ELISA units/ml") xtitle("Age (Years)") name(log18_age, replace)

grc1leg log16_age log18_age,graphregion(fcolor(white))  

oneway sero_log_18 agegp2 if sero_18_bin==1
oneway sero_log_16 agegp2 if sero_16_bin==1
 
restore
preserve
keep if sero_18_bin==1

regress sero_18_cont age
predict fit
twoway (scatter sero_18_cont age) (lfit sero_18_cont age) , name(elisa18_age, replace)
restore

graph combine elisa16_age elisa18_age


tw hist sero_18_cont if sero_18_bin==1, xscale(range(0 1500)) xlab(0(200)1500) yscale(range(0 0.012))title("Anti-HPV18") ylab(0(0.004)0.012, nogrid)  color(maroon)  xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) name(sero18, replace)

tw hist sero_16_cont if sero_16_bin==1, xscale(range(0 1500)) xlab(0(200)1500) yscale(range(0 0.012))title("Anti-HPV16") ylab(0(0.004)0.012, nogrid)  color(navy) lcolor(ltblue) xtitle("ELISA units/ml") legend(off) graphregion(fcolor(white)) name(sero16, replace)
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


