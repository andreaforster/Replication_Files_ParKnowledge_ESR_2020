********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Robustness check interaction with performance
********************************************************************************

* Description
/* This dofile carries out a robustness check where we interact cito
performacne levels with parental knowledge. These analyses are presented in
supplementary appendix SE */

********************************************************************************

global dataDir "H:\Andrea\00_converted_data\VOCL93"
global workingDir "H:\Andrea\parental information\2021-04_replication_files"

global dofiles "${workingDir}\01_dofiles"
global posted "${workingDir}\02_posted"
global graphs "${workingDir}\03_graphs"
global tables "${workingDir}\04_tables"

********************************************************************************

*###############################################################################
* Interaction Performancce and Knowledge
*###############################################################################

use "$posted/3a_imputed_transitions_tertiary.dta", clear

mi estimate, post: logit moveup i.edupar3 zknow ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m1
	
mi estimate, post: logit moveup i.edupar3 zknow zaspire logbooks ///
	zinvolvement zclosure ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m2
	
mi estimate, post: logit movedown2 i.edupar3 zknow ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m3

mi estimate, post: logit movedown2 i.edupar3 zknow zaspire logbooks ///
	zinvolvement zclosure ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m4
	
mi estimate, post: ologit tertiary3 i.edupar3 zknow ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m5

mi estimate, post: ologit tertiary3 i.edupar3 zknow zaspire logbooks ///
	zinvolvement zclosure ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m6

use "$posted/3b_imputed_track5.dta", clear

mi estimate, post: logit havovwo5 i.edupar3 zknow ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m7

mi estimate, post: logit havovwo5 i.edupar3 zknow zaspire logbooks ///
	zinvolvement zclosure ///
	i.track3 zcito female i.ethnicity numkid ///
	c.zknow#c.zcito ///
	, cluster(school)
estimates store m8
	
	esttab m* ///
		using "$tables/appD_interaction_know_performance.rtf", ///
		c(b(star fmt(2)) se(fmt(2))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 
	

		
		
		
		
		
		
		