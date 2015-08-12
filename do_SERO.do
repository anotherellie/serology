**Any antibodies detected

clear
set more off
use "N:\Eking\Prevalence_study_data\Data_files\ALL_3.dta"
cd "N:\Eking\Prevalence_study_data"

gen sero_bin=sero_16_bin
replace sero_bin=1 if sero_18_bin==1
*GRAPHS OF HPV PREV AND BY AGE
*______________________________________________________________

do "N:\Eking\Prevalence_study_data\Do_files\do_seroprev_bar.do"
do "N:\Eking\Prevalence_study_data\Do_files\do_seroprev_bar2.do"

*UNIVARIATE ANALYSES
do "N:\Eking\Prevalence_study_data\Do_files\do_serounivar.do"

*ADJUSTED FOR AGE AND LIFETIME ANALYSES
do "N:\Eking\Prevalence_study_data\Do_files\do_sero_age_ptnrs.do"

*MULTIIVARIATE ANALYSES
do "N:\Eking\Prevalence_study_data\Do_files\do_seromultivar.do"

*ELISA UNITS
do "N:\Eking\Prevalence_study_data\Do_files\do_sero_elisaunits.do"

*IS there a relathionship between anogential concordance and seropositivity?
do "N:\Eking\Prevalence_study_data\Do_files\do_sero_concordance.do"
