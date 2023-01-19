********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Robustness check using a measure of knowledge that only includes
* 10 times
********************************************************************************

* Description
/* This dofile produces an additional analysis where we do principal component
analysis on the knowledge items and only use the 10 items that load high 
on the first factor*/

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

*###############################################################################
* Multiple imputation
*###############################################################################

* set random number seed to be able to replicate results
set seed 42083

/* generate a duplicate of the DV, as I want to compare an imputed DV to a 
listwise deleted DV */
clonevar moveup_mi = moveup
clonevar movedown_mi = movedown

/* Set data to multiple imputation formate, register variables that need 
imputations, carry out multiple imputation using chained equations */

mi set mlong 
mi misstable sum
mi register imputed advice edupar3 soc_class parinc zmotiv1 ///
	zknow2 zcito zdutch3 zmath3 zmotiv3 ethnicity numkid ///
	zaspire logbooks zinvolvement znetwork zclosure moveup_mi movedown_mi
mi register regular female track3 birthyr tertiary3

mi impute chained (pmm, knn(5)) advice  /// pmm for continuous variables
	parinc zcito zdutch3 zmath3 zmotiv1 zmotiv3 numkid zknow2 ///
	zaspire logbooks zinvolvement znetwork zclosure ///
	(ologit, augment) edupar3 /// ologit for ordinal variables
	(mlogit, augment) soc_class ethnicity ///
	(logit, augment) moveup_mi movedown_mi  /// logit for dichotomous variables
	= female track3 birthyr tertiary3, /// complete variables
	add(20) dots replace // 20 imputations

save "$posted/imputed_data_transitions_tertiary_zknow2.dta", replace




*###############################################################################
* Table 2: (Ordinal) Logistic Regression Models
*###############################################################################

********************************************************************************
* Models with imputed data
********************************************************************************

*-------------------------------------------------------------------------------
* Logistic Regression models with Tertiary Degree as outcome (no KHB correction)
*-------------------------------------------------------------------------------

use "$posted/imputed_data_transitions_tertiary_zknow2.dta", clear

*** MODEL 1 ***

	mi estimate, post: ologit tertiary3 i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store Ib

*** MODEL 2 ***

	mi estimate, post: ologit tertiary3 i.edupar3 ///
		zknow2 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store IIb
	
*** MODEL 3 ***

	mi estimate, post: ologit tertiary3 i.edupar3 ///
		zaspire logbooks zinvolvement zclosure ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store IIIb

*** MODEL 4	***

	mi estimate, post: ologit tertiary3 i.edupar3 ///
		zknow2 zaspire logbooks zinvolvement zclosure ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store IVb

*-------------------------------------------------------------------------------
*** ESTIMATES TABLE ***
*-------------------------------------------------------------------------------

	esttab  Ib IIb IIIb IVb ///
		using "$tables/tab2_logit_tertiary_zknow2.rtf", ///
		c(b(star fmt(3)) se(fmt(3))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 



*-------------------------------------------------------------------------------
* Logistic Regression models with upward transitions as outcome (no KHB correction)
*-------------------------------------------------------------------------------

*** MODEL 1 ***

	mi estimate, post: logit moveup i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store A_up

*** MODEL 2 ***

	mi estimate, post: logit moveup i.edupar3 ///
		zknow ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store B_up

*** MODEL 3 ***

	mi estimate, post: logit moveup i.edupar3 ///
		logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store C_up

*** MODEL 4	***

	mi estimate, post: logit moveup i.edupar3 ///
		zknow logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store D_up

*-------------------------------------------------------------------------------
* Logistic Regression models with Downward transitions as outcome (no KHB correction)
*-------------------------------------------------------------------------------

*** MODEL 1 ***

	mi estimate, post: logit movedown2 i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store A_down

*** MODEL 2 ***

	mi estimate, post: logit movedown2 i.edupar3 ///
		zknow ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store B_down
	
*** MODEL 3 ***

	mi estimate, post: logit movedown2 i.edupar3 ///
		logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store C_down

*** MODEL 4	***
	
	mi estimate, post: logit movedown2 i.edupar3 ///
		zknow logbooks zinvolvement zclosure zaspire ///
		i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school)
	estimates store D_down

*-------------------------------------------------------------------------------
*** ESTIMATES TABLE ***
*-------------------------------------------------------------------------------

	esttab A_up B_up C_up D_up A_down B_down C_down D_down ///
		using "$tables/app_transitions_logit_factoranalysis.rtf", ///
		c(b(star fmt(3)) se(fmt(3))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 
	
