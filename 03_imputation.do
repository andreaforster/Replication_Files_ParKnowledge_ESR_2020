********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Imputation model for DVs "upward transition", "downward transition", "tertiary degree"
********************************************************************************

* Description
/* This dofile implements multiple imputation for missing values on all
independent variables for the analysis with "upward transition", 
"downward transition", and "tertiary degree" as 
dependent variables */

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
* Load prepared data set 
********************************************************************************
use "$posted\2_prepared.dta", clear

count

*###############################################################################
* Multiple imputation Transitions and Tertiary Degree
*###############################################################################

preserve 
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
		zknow zcito zdutch3 zmath3 zmotiv3 ethnicity numkid ///
		zaspire logbooks zinvolvement znetwork zclosure moveup_mi movedown_mi
	mi register regular female track3 birthyr tertiary3

	mi impute chained (pmm, knn(5)) advice  /// pmm for continuous variables
		parinc zcito zdutch3 zmath3 zmotiv1 zmotiv3 numkid zknow ///
		zaspire logbooks zinvolvement znetwork zclosure ///
		(ologit, augment) edupar3 /// ologit for ordinal variables
		(mlogit, augment) soc_class ethnicity ///
		(logit, augment) moveup_mi movedown_mi  /// logit for dichotomous variables
		= female track3 birthyr tertiary3, /// complete variables
		add(20) dots replace // 20 imputations

	merge m:1 srtnum rin using "$posted/robust_movedown.dta"
		
	save "$posted/3a_imputed_transitions_tertiary.dta", replace

restore



*###############################################################################
* Multiple imputation Track in 11th grade
*###############################################################################

preserve

	* set random number seed to be able to replicate results
	set seed 42083

	/* generate a duplicate of the DV, as I want to compare an imputed DV to a 
	listwise deleted DV */
	clonevar havovwo_mi = havovwo5

	/* Set data to multiple imputation formate, register variables that need 
	imputations, carry out multiple imputation using chained equations */

	mi set mlong 
	mi misstable sum
	mi register imputed advice edupar3 soc_class parinc zmotiv1 ///
		zknow zcito zdutch3 zmath3 zmotiv3 ethnicity numkid ///
		zaspire logbooks zinvolvement znetwork zclosure havovwo_mi 
	mi register regular female track3 birthyr tertiary3

	mi impute chained (pmm, knn(5)) advice  /// pmm for continuous variables
		parinc zcito zdutch3 zmath3 zmotiv1 zmotiv3 numkid zknow ///
		zaspire logbooks zinvolvement znetwork zclosure ///
		(ologit, augment) edupar3 /// ologit for ordinal variables
		(mlogit, augment) soc_class ethnicity ///
		(logit, augment) havovwo_mi  /// logit for dichotomous variables
		= female track3 birthyr tertiary3, /// complete variables
		add(20) dots replace // 20 imputations

	save "$posted/3b_imputed_track5.dta", replace

restore

