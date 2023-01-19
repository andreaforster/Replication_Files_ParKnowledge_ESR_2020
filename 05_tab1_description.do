********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Descriptive Statistics
********************************************************************************

* Description
/* This dofile produces the descriptive statistics presented in Table 1 of 
the paper */

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

********************************************************************************
* Descriptive Statistics Variables - MI sample
********************************************************************************

preserve 
use "$posted/3a_imputed_transitions_tertiary.dta", clear


tab edupar3, gen(dum_edupar3)
tab ethnicity, gen(dum_ethnic)
tab tertiary3, gen(dum_tert)

*** overall ***

mi estimate, post: mean female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 
estimates store ov

mi estimate, post: mean moveup
mi estimate, post: mean movedown2

restore

preserve 
use "$posted/3a_imputed_transitions_tertiary.dta", clear

*** By Track (Table 1) ***
tab edupar3, gen(dum_edupar3)
tab ethnicity, gen(dum_ethnic)
tab tertiary3, gen(dum_tert)

mi estimate, post: mean female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 ///
	if track3==1

estimates store I 

mi estimate: mean moveup if track3==1
mi estimate: mean movedown2 if track3==1
	
mi estimate, post: mean female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 ///
	if track3==2

estimates store II 

mi estimate: mean moveup if track3==2
mi estimate: mean movedown2 if track3==2

mi estimate, post: mean female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 ///
	if track3==3
estimates store III
	
mi estimate: mean moveup if track3==3
mi estimate: mean movedown2 if track3==3

mi estimate, post: mean female zknow dum_edupar31 dum_edupar32 dum_edupar33 ///
	dum_ethnic1 dum_ethnic2 dum_ethnic3 dum_ethnic4 dum_ethnic5 numkid ///
	zcito ///
	zaspire logbooks zinvolvement zclosure dum_tert1 dum_tert2 dum_tert3 ///
	if track3==4
estimates store IV 

mi estimate: mean movedown2 if track3==4
mi estimate: mean tertiary3 if track3==4


esttab I II III IV ov using "$tables/tab1_descriptives.rtf" ///
	, cells(b(fmt(2))) rtf replace

restore 
