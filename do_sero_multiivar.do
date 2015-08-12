clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"
*drop participants without adequate specimens
encode adeq_sero_16, gen(ad_16)
encode adeq_sero_18, gen(ad_18)
keep if ad_16==1|ad_18==1


recode ethnicgp2 3=2 4=3
lab values ethnicgp et



local sero sero_16_bin sero_18_bin


logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life
testparm i.gp_nummen_life

logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life
testparm i.gp_nummen_life

*Stepwise HPV16
*__________________________________________________________________________________________________
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life if position<.
estimates store b
lrtest b a
*keep position in

logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position if lst_rec_anl3<.
estimates store b
lrtest b a
*keep lst_rec_anl in
*check position
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.lst_rec_anl3 if position<.
estimates store b
lrtest b a


logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.anl_drug
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 if anl_drug<.
estimates store b
lrtest b a
*anl_drug not sig

logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 age_ptnr1
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 if age_ptnr1<.
estimates store b
lrtest b a
*age_ptnr1 not sig


logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.concur
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 if concur<.
estimates store b
lrtest b a
*concur not sig

logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 if gp_anlptnrs_lstyr2<.
estimates store b
lrtest b a
*KEEP anal partners last year not sig

logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 i.gp_new_anlptnrs_lstyr2
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 if gp_new_anlptnrs_lstyr2<.
estimates store b
lrtest b a
*NEW NOT SIG

logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 i.gp_anlptnrs_nocdm_lstyr2
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 if gp_anlptnrs_nocdm_lstyr2<.
estimates store b
lrtest b a
*NOCDM NOT SIG

*CHECK LIFETIME PARTNRS p value
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 if gp_nummen_life<.
estimates store b
lrtest b a

*CHECK posiution p value
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.position i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age  i.gp_anlptnrs_lstyr2 i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 if position<.
estimates store b
lrtest b a
*position OUT

*check lst_rec_anl
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age  i.gp_anlptnrs_lstyr2 i.gp_anlptnrs_lstyr2 if lst_rec_anl3<.
estimates store b
lrtest b a
*KEEP LST_REC_ANL

logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 
estimates store a
logistic sero_16_bin i.genital_HPV16 i.hiv age i.lst_rec_anl3 i.gp_anlptnrs_lstyr2 if gp_nummen_life<.
estimates store b
lrtest b a


**********
*FINAL
*____________
logistic sero_16_bin i.genital_HPV16 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.gp_anlptnrs_lstyr2

*CHECK FOR COLLINEARITY if VIF>10 then worry less than2 is fine. 
collin genital_HPV16 hiv age gp_nummen_life lst_rec_anl3 gp_anlptnrs_lstyr2
collin gp_nummen_life gp_anlptnrs_lstyr2
*_______________________________________________________________________

*Stepwise HPV18
*__________________________________________________________________________________________________
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.genital_HPV16
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life if genital_HPV16<.
estimates store b
lrtest b a


logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.gp_anlptnrs_lstyr2
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life if gp_anlptnrs_lstyr2<.
estimates store b
lrtest b a
*gp_analptnrs_lstyr NOT SIG

logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.gp_new_anlptnrs_lstyr2
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life if gp_new_anlptnrs_lstyr2<.
estimates store b
lrtest b a
*gp_new_anlptnrs NOT SIG

logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life if lst_rec_anl3<.
estimates store b
lrtest b a
*KEEP RECENT ANAL SEX

logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.anl_drug
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3 if anl_drug<.
estimates store b
lrtest b a
*KEEP ANAL DRUG (<0.1)

*CHECK lst_rec_anl3
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.anl_drug
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.anl_drug if lst_rec_anl3<.
estimates store b
lrtest b a
*KEEP ANL_DRUG NAD LST_REC_ANL3

*CHECK CONCUR
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.anl_drug i.concur
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.anl_drug if concur<.
estimates store b
lrtest b a


*CHECK gp_nummen_life
logistic sero_18_bin i.genital_HPV18 i.hiv age i.gp_nummen_life i.lst_rec_anl3 i.anl_drug
estimates store a
logistic sero_18_bin i.genital_HPV18 i.hiv age i.lst_rec_anl3 i.anl_drug if gp_nummen_life<.
estimates store b
lrtest b a


**********
*FINAL
*____________
logistic sero_18_bin i.genital_HPV18 i.hiv age gp_nummen_life i.lst_rec_anl3 i.anl_drug



