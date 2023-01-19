********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Analysis of transitions for separate tracks
********************************************************************************

* Description
/* This dofile carries out logistic regression models separately for each
track and looks at upward and downward transitions. The results are presented
in table 3 in the paper"*/

********************************************************************************

global dataDir "H:\Andrea\00_converted_data\VOCL93"
global workingDir "H:\Andrea\parental information\2021-04_replication_files"

global dofiles "${workingDir}\01_dofiles"
global posted "${workingDir}\02_posted"
global graphs "${workingDir}\03_graphs"
global tables "${workingDir}\04_tables"

********************************************************************************

use "$posted/3a_imputed_transitions_tertiary.dta", clear


preserve

forval x = 1/3 {

	*-------------------------------------------------------------------------------
	* upward transitions
	*-------------------------------------------------------------------------------
	estimates clear 

	
	
	*** MODEL 1 ***
	
	mi estimate, post: logit moveup i.edupar3 ///
			zcito female numkid if track3==`x' ///
			, cluster(school)
		estimates store A_up

	*** MODEL 2 ***

		mi estimate, post: logit moveup i.edupar3 ///
			zknow ///
			zcito female numkid if track3==`x' ///
			, cluster(school)
		estimates store B_up

	*** MODEL 3 ***

		mi estimate, post: logit moveup i.edupar3 ///
			logbooks zinvolvement zclosure zaspire ///
			zcito female numkid if track3==`x' ///
			, cluster(school)
		estimates store C_up

	*** MODEL 4	***

		mi estimate, post: logit moveup i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			zcito female numkid if track3==`x' ///
			, cluster(school)
		estimates store D_up
		
	esttab A_up B_up C_up D_up  ///
	using "$tables/robust_upward_logit_`x'.rtf", ///
	c(b(star fmt(2)) se(fmt(2))) ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
	replace b(%8.3f) pr2 label nobaselevels nodepvar ///
	title("") ///
	addnote("Source: VOCL 1993 cohort") 
	
}
*

restore 

	*-------------------------------------------------------------------------------
	* downward transitions
	*-------------------------------------------------------------------------------
forval x = 1/4 {
estimates clear

	*** MODEL 1 ***

		mi estimate, post: logit movedown2 i.edupar3 ///
			zcito female i.ethnicity numkid if track3==`x' ///
			, cluster(school)
		estimates store A_down

	*** MODEL 2 ***

		mi estimate, post: logit movedown2 i.edupar3 ///
			zknow ///
			zcito female i.ethnicity numkid if track3==`x' ///
			, cluster(school)
		estimates store B_down
		
	*** MODEL 3 ***

		mi estimate, post: logit movedown2 i.edupar3 ///
			logbooks zinvolvement zclosure zaspire ///
			zcito female i.ethnicity numkid if track3==`x' ///
			, cluster(school)
		estimates store C_down

	*** MODEL 4	***
		
		mi estimate, post: logit movedown2 i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			zcito female i.ethnicity numkid if track3==`x' ///
			, cluster(school)
		estimates store D_down

	*-------------------------------------------------------------------------------
	*** ESTIMATES TABLE ***
	*-------------------------------------------------------------------------------

		esttab A_down B_down C_down D_down ///
			using "$tables/robust_downward_logit_`x'.rtf", ///
			c(b(star fmt(2)) se(fmt(2))) ///
			star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
			replace b(%8.3f) pr2 label nobaselevels nodepvar ///
			title("") ///
			addnote("Source: VOCL 1993 cohort") 

}


********************************************************************************
* Separate models for the 20 imputations + averaging to obtain Pseudo R2
********************************************************************************

*-------------------------------------------------------------------------------
* Upward transitions
*-------------------------------------------------------------------------------

forval x=1/3 {

	*** MODEL 1 ***
		
		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			zcito zdutch3 female numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
			
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 1 = " as res r2_p
		
	*** MODEL 2 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			zknow ///
			zcito zdutch3 female numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p

	*** MODEL 3 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			logbooks zinvolvement zclosure zaspire  ///
			zcito zdutch3 female numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p) 

		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 3 = " as res r2_p
		
	*** MODEL 4 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			zcito zdutch3 female numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 4 = " as res r2_p
}

*-------------------------------------------------------------------------------
* Downward transition
*-------------------------------------------------------------------------------

forval x = 1/1 {
	*** MODEL 1 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			zcito zdutch3 female i.ethnicity numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
			
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 1 = " as res r2_p

	*** MODEL 2 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			zknow ///
			zcito zdutch3 female i.ethnicity numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p
		
	*** MODEL 3 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			logbooks zinvolvement zclosure zaspire ///
			zcito zdutch3 female i.ethnicity numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)

		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 3 = " as res r2_p
		
	*** MODEL 4 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			zcito zdutch3 female i.ethnicity numkid if track3==`x' ///
			, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 4 = " as res r2_p
}

