********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Logistic Regression models with the four DVs
********************************************************************************

* Description
/* This dofile runs logistic regression models that are presented in table 2
in the paper */

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
* Upward Transition
********************************************************************************

preserve 
	use "$posted/3a_imputed_transitions_tertiary.dta", clear

	*-------------------------------------------------------------------------------
	* Logistic Regression Models
	*-------------------------------------------------------------------------------

	*** MODEL 1 ***

		mi estimate, post: logit moveup i.edupar3 ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store I_up

	*** MODEL 2 ***

		mi estimate, post: logit moveup i.edupar3 ///
			zknow ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store II_up

	*** MODEL 3 ***

		mi estimate, post: logit moveup i.edupar3 ///
			logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store III_up

	*** MODEL 4	***

		mi estimate, post: logit moveup i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store IV_up
		
	*-------------------------------------------------------------------------------
	* Average Pseudo R2
	*-------------------------------------------------------------------------------	

	*** MODEL 1 ***
		
		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
			
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 1 = " as res r2_p
		
	*** MODEL 2 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			zknow ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p

	*** MODEL 3 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			logbooks zinvolvement zclosure zaspire  ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)

		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 3 = " as res r2_p
		
	*** MODEL 4 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit moveup i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 4 = " as res r2_p

restore
		
********************************************************************************
* Downward Transition
********************************************************************************

preserve 

	use "$posted/3a_imputed_transitions_tertiary.dta", clear

	*-------------------------------------------------------------------------------
	* Logistic Regression Models
	*-------------------------------------------------------------------------------

	*** MODEL 1 ***

		mi estimate, post: logit movedown2 i.edupar3 ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store I_down

	*** MODEL 2 ***

		mi estimate, post: logit movedown2 i.edupar3 ///
			zknow ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store II_down
		
	*** MODEL 3 ***

		mi estimate, post: logit movedown2 i.edupar3 ///
			logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store III_down

	*** MODEL 4	***
		
		mi estimate, post: logit movedown2 i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store IV_down
		
	*-------------------------------------------------------------------------------
	* Average Pseudo R2
	*-------------------------------------------------------------------------------

	*** MODEL 1 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
			
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 1 = " as res r2_p

	*** MODEL 2 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			zknow ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p
		
	*** MODEL 3 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)

		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 3 = " as res r2_p
		
	*** MODEL 4 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit movedown2 i.edupar3 ///
			zknow logbooks zinvolvement zclosure zaspire ///
			i.track3 zcito zdutch3 female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 4 = " as res r2_p

restore


********************************************************************************
* Track 11th Grade
********************************************************************************

preserve 

	use "$posted/3b_imputed_track5.dta", clear

	*-------------------------------------------------------------------------------
	* Logistic Regression Models
	*-------------------------------------------------------------------------------

	*** MODEL 1 ***

		mi estimate, post: logit havovwo5 i.edupar3 ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store I_track

	*** MODEL 2 ***

		mi estimate, post: logit havovwo5 i.edupar3 ///
			zknow ///
			i.track3 zcito female i.ethnicity numkid ///
			, cluster(school)
		estimates store II_track

	*** MODEL 3 ***

		mi estimate, post: logit havovwo5 i.edupar3 ///
			zaspire logbooks zinvolvement zclosure ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store III_track

	*** MODEL 4	***

		mi estimate, post: logit havovwo5 i.edupar3 ///
			zknow zaspire logbooks zinvolvement zclosure ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store IV_track

	*-------------------------------------------------------------------------------
	* Average Pseudo R2
	*-------------------------------------------------------------------------------

	*** Model 1 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit havovwo5 i.edupar3 ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
			
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 1 = " as res r2_p

	*** Model 2 ***
		
		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit havovwo5 i.edupar3 zknow ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p
		
	*** Model 3 ***	
		
		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit havovwo5 i.edupar3 zaspire logbooks ///
			zinvolvement zclosure ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)

		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 3 = " as res r2_p
		
	*** Model 4 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': logit havovwo5 i.edupar3 zknow zaspire logbooks ///
			zinvolvement zclosure ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 4 = " as res r2_p	

restore 

********************************************************************************
* Tertiary Degree
********************************************************************************

preserve 

	use "$posted/3a_imputed_transitions_tertiary.dta", clear

	*-------------------------------------------------------------------------------
	* Logistic Regression Models
	*-------------------------------------------------------------------------------

	*** MODEL 1 ***

		mi estimate, post: ologit tertiary3 i.edupar3 ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store I_tert

	*** MODEL 2 ***

		mi estimate, post: ologit tertiary3 i.edupar3 ///
			zknow ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store II_tert
		
	*** MODEL 3 ***

		mi estimate, post: ologit tertiary3 i.edupar3 ///
			zaspire logbooks zinvolvement zclosure ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store III_tert

	*** MODEL 4	***

		mi estimate, post: ologit tertiary3 i.edupar3 ///
			zknow zaspire logbooks zinvolvement zclosure ///
			i.track3 zcito female i.ethnicity numkid, cluster(school)
		estimates store IV_tert

	*-------------------------------------------------------------------------------
	* Average Pseudo R2
	*-------------------------------------------------------------------------------
			
	*** MODEL 1 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': ologit tertiary3 i.edupar3 ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p
		
	*** MODEL 2 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': ologit tertiary3 i.edupar3 zknow ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 2 = " as res r2_p

	*** MODEL 3 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': ologit tertiary3 i.edupar3 logbooks ///
			zinvolvement zclosure zaspire  ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)

		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 3 = " as res r2_p
		
	*** MODEL 4 ***

		mi query	
		local M = r(M)	
		scalar r2_p = 0
		quietly mi xeq 1/`M': ologit tertiary3 i.edupar3 logbooks ///
			zinvolvement zclosure zaspire zknow ///
			i.track3 zcito female i.ethnicity numkid, cluster(school) ///
			; scalar r2_p = r2_p + e(r2_p)
		
		scalar r2_p = r2_p/`M'
		di as txt "PR2 over imputed data Model 4 = " as res r2_p
				
restore	
	
*-------------------------------------------------------------------------------
*** ESTIMATES TABLES ***
*-------------------------------------------------------------------------------

	esttab I_up II_up III_up IV_up I_down II_down III_down IV_down ///
		using "$tables/tab2_transitions.rtf", ///
		c(b(star fmt(2)) se(fmt(2))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 
		
		
	esttab I_track II_track III_track IV_track I_tert II_tert III_tert IV_tert ///
		using "$tables/tab2_havovwo_tertiary.rtf", ///
		c(b(star fmt(2)) se(fmt(2))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) pr2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort") 

	


