********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Robustness check listwise deletion
********************************************************************************

* Description
/* This dofile carries out the main analysis with listwise deleted data instead
of multiple imputation*/

********************************************************************************

global dataDir "H:\Andrea\00_converted_data\VOCL93"
global workingDir "H:\Andrea\parental information\2021-04_replication_files"

global dofiles "${workingDir}\01_dofiles"
global posted "${workingDir}\02_posted"
global graphs "${workingDir}\03_graphs"
global tables "${workingDir}\04_tables"

********************************************************************************

use "$posted\2_prepared.dta", clear
count


* ADD MOVEDOWN FOR VBO STUDENTS (REVIEWER REQUEST)
merge 1:1 srtnum rin using "$posted/robust_movedown.dta"



********************************************************************************
* Patterns of Missingness
********************************************************************************

sum female track3 ethnicity numkid ///
	zcito  ///
	edupar3 ///
	zknow zaspire logbooks zinvolvement zclosure school ///
	moveup movedown2 havovwo5 tertiary3 

bys school: sum female track3 ethnicity numkid ///
	zcito  ///
	edupar3 ///
	zknow zaspire logbooks zinvolvement zclosure school ///
	moveup movedown2 havovwo5 tertiary3 
	
fre w_cito1 
fre w_childquest1 
fre w_childquest3
fre w_parquest1 
fre w_parquest3 
fre w_dutch3 
fre w_math3 


********************************************************************************
* Listwise Deletion
********************************************************************************

regress female track3 ethnicity numkid ///
	zcito  ///
	edupar3 ///
	zknow zaspire logbooks zinvolvement zclosure 

gen sample = e(sample)
drop if sample !=1
	
********************************************************************************
* Main Models
********************************************************************************

*-------------------------------------------------------------------------------
* Upward transition
*-------------------------------------------------------------------------------

*** MODEL 1 ***

	logit moveup i.edupar3 ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store A_up

*** MODEL 2 ***

	logit moveup i.edupar3 ///
		zknow ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store B_up

*** MODEL 3 ***

	logit moveup i.edupar3 ///
		logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store C_up

*** MODEL 4	***

	logit moveup i.edupar3 ///
		zknow logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store D_up

*-------------------------------------------------------------------------------
* Downward Transition
*-------------------------------------------------------------------------------

*** MODEL 1 ***

	logit movedown2 i.edupar3 ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store A_down

*** MODEL 2 ***

	logit movedown2 i.edupar3 ///
		zknow ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store B_down
	
*** MODEL 3 ***

	logit movedown2 i.edupar3 ///
		logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store C_down

*** MODEL 4	***
	
	logit movedown2 i.edupar3 ///
		zknow logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store D_down

*-------------------------------------------------------------------------------
* Havovwo 5
*-------------------------------------------------------------------------------

*** MODEL 1 ***

	logit havovwo5 i.edupar3 ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store Ia

*** MODEL 2 ***

	logit havovwo5 i.edupar3 ///
		zknow ///
		i.track3 zcito female i.ethnicity numkid ///
		, cluster(school)
	estimates store IIa

*** MODEL 3 ***

	logit havovwo5 i.edupar3 ///
		zaspire logbooks zinvolvement zclosure ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store IIIa

*** MODEL 4	***

	logit havovwo5 i.edupar3 ///
		zknow zaspire logbooks zinvolvement zclosure ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store IVa
	
*-------------------------------------------------------------------------------
* Tertiary 
*-------------------------------------------------------------------------------

*** MODEL 1 ***

	ologit tertiary3 i.edupar3 ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store Ib

*** MODEL 2 ***

	ologit tertiary3 i.edupar3 ///
		zknow ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store IIb
	
*** MODEL 3 ***

	ologit tertiary3 i.edupar3 ///
		zaspire logbooks zinvolvement zclosure ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store IIIb

*** MODEL 4	***

	ologit tertiary3 i.edupar3 ///
		zknow zaspire logbooks zinvolvement zclosure ///
		i.track3 zcito female i.ethnicity numkid, cluster(school)
	estimates store IVb

	
*-------------------------------------------------------------------------------
*** ESTIMATES TABLE ***
*-------------------------------------------------------------------------------

	esttab A_up B_up C_up D_up ///
		A_down B_down C_down D_down ///
		Ia IIa IIIa IVa ///
		Ib IIb IIIb IVb ///
		using "$tables/robust_listwise_logit.rtf", ///
		c(b(star fmt(2)) se(fmt(2))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 
		
		
*###############################################################################
* KHB Models
*###############################################################################

********************************************************************************
* Upward Transitions
********************************************************************************

preserve

	
*** Compare Model 1 and 2 ***

	khb logit moveup i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school) disentangle
	est store khb_up12

	
*** Compare Model 3 and 4 ***
	
	khb logit moveup i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school) disentangle
	est store khb_up34
	
restore 

********************************************************************************
* Downward Transitions
********************************************************************************

preserve

	
*** Compare Model 1 and 2 ***

	khb logit movedown2 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school) disentangle
	est store khb_down12
	
*** Compare Model 3 and 4 ***
	
	khb logit movedown2 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school) disentangle
	est store khb_down34
restore 

********************************************************************************
* Track 11th Grade
********************************************************************************

preserve

	
*** Compare Model 1 and 2 ***

	khb logit havovwo5 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school) disentangle
	est store khb_track12
	
*** Compare Model 3 and 4 ***
	
	khb logit havovwo5 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school) disentangle
	est store khb_track34
	
restore 

********************************************************************************
* Tertiary Degree
********************************************************************************

preserve

	
*** Compare Model 1 and 2 ***

	khb ologit tertiary3 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school) disentangle
	est store khb_tert12
	
*** Compare Model 3 and 4 ***
	
	khb ologit tertiary3 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school) disentangle
	est store khb_tert34
	
restore 

	esttab ///
		khb_down12 khb_down34 ///
		using "$tables/robust_listwise_khb_newmovedown.rtf", ///
		c(b(star fmt(2)) se(fmt(2))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 
