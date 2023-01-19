********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Imputation Diagnostics
********************************************************************************

* Description
/* This dofile carries out imputation diagnostics for the imputation model
run in 3a_imputation_model_transitions_tertiary */

********************************************************************************

global dataDir "H:\Andrea\00_converted_data\VOCL93"
global workingDir "H:\Andrea\parental information\2021-04_replication_files"

global dofiles "${workingDir}\01_dofiles"
global posted "${workingDir}\02_posted"
global graphs "${workingDir}\03_graphs"
global tables "${workingDir}\04_tables"

********************************************************************************

version 16
clear all
set more off

********************************************************************************

use "$posted/3a_imputed_transitions_tertiary.dta", clear

midiagplots edupar3 zknow zaspire logbooks zinvolvement zclosure ///
		zcito zdutch3 ethnicity numkid ///
		, ks sample(observed imputed) saving("$graphs/midiag1",replace) ///
		title("") scheme(s2mono)


graph combine "$graphs/midiag1_1_zknow.gph" "$graphs/midiag1_1_zaspire.gph" ///
	"$graphs/midiag1_1_logbooks.gph" "$graphs/midiag1_1_zinvolvement.gph" ///
	"$graphs/midiag1_1_zclosure.gph" "$graphs/midiag1_1_zcito.gph" ///
	"$graphs/midiag1_1_numkid.gph" ///
	, ycommon title("") scheme(s2mono)

		
midiagplots edupar3, combine ks saving("$graphs/midiag_edupar3", replace) 
midiagplots zknow, combine ks saving ("$graphs/midiag_zknow", replace)
midiagplots zcito, combine ks saving ("$graphs/midiag_zcito", replace)
midiagplots zaspire, combine ks saving ("$graphs/midiag_zaspire", replace)
midiagplots logbooks, combine ks saving ("$graphs/midiag_logbooks", replace)
midiagplots zinvolvement, combine ks saving ("$graphs/midiag_zinvolvement", replace) 
midiagplots zclosure, combine ks saving ("$graphs/midiag_zclosure", replace) 
midiagplots zdutch3, combine ks saving ("$graphs/midiag_zdutch3", replace) 
midiagplots ethnicity, combine ks saving ("$graphs/midiag_ethnicity", replace) 
midiagplots numkid, combine ks saving ("$graphs/midiag_numkid", replace) 


reg zknow advice zcito zdutch3 zmath3 zmotiv3 numkid ///
	zaspire logbooks zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==2
rvfplot 


reg zcito zknow advice zdutch3 zmath3 zmotiv3 numkid ///
	zaspire logbooks zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg zdutch3 zcito zknow advice zmath3 zmotiv3 numkid ///
	zaspire logbooks zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg numkid zdutch3 zcito zknow advice zmath3 zmotiv3 ///
	zaspire logbooks zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg numkid zdutch3 zcito zknow advice zmath3 zmotiv3 ///
	zaspire logbooks zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg zaspire numkid zdutch3 zcito zknow advice zmath3 zmotiv3 ///
	logbooks zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg logbooks zaspire numkid zdutch3 zcito zknow advice zmath3 zmotiv3 ///
	zinvolvement znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg zinvolvement logbooks zaspire numkid zdutch3 zcito zknow advice ///
	zmath3 zmotiv3 ///
	znetwork zclosure i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 

reg zclosure zinvolvement logbooks zaspire numkid zdutch3 zcito ///
	zknow advice zmath3 zmotiv3 ///
	znetwork i.edupar3 i.soc_class ///
	i.ethnicity i.moveup_mi i.movedown_mi i.female i.track3 ///
	birthyr i.tertiary3 if _mi_m==1
rvfplot 


********************************************************************************
* Descriptive Statistics Variables - Original Data
********************************************************************************

preserve
use "$posted/2_prepared.dta", clear
count


tab edupar3, gen(dum_edupar3)
tab ethnicity, gen(dum_ethnic)
tab tertiary3, gen(dum_tert)

estpost sum female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito zdutch3 ///
	zknow zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 ///
	moveup movedown2
estimates store I	
restore

********************************************************************************
* Descriptive Statistics Variables - Listwise Deletion
********************************************************************************

preserve
use "$posted\2_prepared.dta", clear
count

regress tertiary female track3 ethnicity numkid ///
	zcito  ///
	edupar3 ///
	zknow zaspire logbooks zinvolvement zclosure 

gen sample = e(sample)
drop if sample !=1


tab edupar3, gen(dum_edupar3)
tab ethnicity, gen(dum_ethnic)
tab tertiary3, gen(dum_tert)

estpost sum female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito zdutch3 ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 ///
	moveup movedown2
	
estimates store II
restore 

esttab I II using "$tables/tab_imputation_means.rtf" ///
	, cells("mean(fmt(3)) count(fmt(0))") noobs label replace
	
********************************************************************************
* Descriptive Statistics Variables - MI sample
********************************************************************************

preserve 
use "$posted/3a_imputed_transitions_tertiary.dta", clear


tab edupar3, gen(dum_edupar3)
tab ethnicity, gen(dum_ethnic)
tab tertiary3, gen(dum_tert)

mi estimate, post: mean female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito zdutch3 ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3
estimates store imp
esttab imp, cells(b(fmt(3)))
	
mi estimate, post: mean moveup 
mi estimate, post: mean movedown2

restore




	

