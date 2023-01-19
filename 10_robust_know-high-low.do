********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Robustness check with separate measures for knowledge
********************************************************************************

* Description
/* This dofile produces a robustness check where we distinguish between 
knowledge on high and knowledge on low tracks. The results are presented in 
appendix SF*/

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

use "$posted\2_prepared.dta", clear

* set random number seed to be able to replicate results
set seed 50383

/* generate a duplicate of the DV, as I want to compare an imputed DV to a 
listwise deleted DV */
clonevar moveup_mi = moveup
clonevar movedown_mi = movedown

/* generate the interaction effect from the model by hand to also have 
it imputed */

/* Set data to multiple imputation formate, register variables that need 
imputations, carry out multiple imputation using chained equations */

mi set mlong 
mi misstable sum
mi register imputed advice edupar3 soc_class ///
	zknow_low zknow_high zcito zdutch3 zmath3 zmotiv3 ethnicity numkid ///
	zaspire logbooks zinvolvement znetwork zclosure moveup_mi movedown_mi 
mi register regular female track3 birthyr tertiary3

mi impute chained (pmm, knn(5)) advice  /// pmm for continuous variables
	zknow_low zknow_high zcito zdutch3 zmath3 zmotiv3 numkid ///
	zaspire logbooks zinvolvement znetwork zclosure ///
	(ologit) edupar3  /// ologit for ordinal variables
	(mlogit, augment) soc_class ethnicity ///
	(logit) moveup_mi movedown_mi /// logit for dichotomous variables
	= female track3 birthyr tertiary3, /// complete variables
	add(20) dots replace // 20 imputations

save "$posted/10_imputed_know-low-high.dta", replace
	
	
use "$posted/10_imputed_know-low-high.dta", clear
	
mi xeq: corr zknow_low zknow_high

mi estimate: ologit tertiary i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid ///
		zknow_low zknow_high ///
		if track3==1 | track3==2, cluster(school) 
		
* separate models to average Pseudo R2
	mi query	
	local M = r(M)	
	scalar r2_p = 0
	mi xeq 1/`M': ologit tertiary i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid ///
		zknow_low zknow_high ///
		if track3==1 | track3==2, cluster(school) ///
		; scalar r2_p = r2_p + e(r2_p)

	scalar r2_p = r2_p/`M'
	di as txt "PR2 over imputed data Model 1 = " as res r2_p
		
mi estimate: ologit tertiary i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid ///
		zknow_low zknow_high ///
		if track3==3 | track3==4, cluster(school) 

* separate models to average Pseudo R2
	mi query	
	local M = r(M)	
	scalar r2_p = 0
	mi xeq 1/`M': ologit tertiary i.edupar3 ///
		i.track3 zcito zdutch3 female i.ethnicity numkid ///
		zknow_low zknow_high ///
		if track3==3 | track3==4, cluster(school) ///
		; scalar r2_p = r2_p + e(r2_p)

	scalar r2_p = r2_p/`M'
	di as txt "PR2 over imputed data Model 2 = " as res r2_p
