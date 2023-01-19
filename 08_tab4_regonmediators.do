********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Regression on mediator knowledge
********************************************************************************

* Description
/* This dofile produces the results presented in table 4. We regress the mediator
knowledge on parental education to test whether there is an association between
the two variables. This is a prerequisite for the subsequent mediation analysis
*/

********************************************************************************

global dataDir "H:\Andrea\00_converted_data\VOCL93"
global workingDir "H:\Andrea\parental information\2021-04_replication_files"

global dofiles "${workingDir}\01_dofiles"
global posted "${workingDir}\02_posted"
global graphs "${workingDir}\03_graphs"
global tables "${workingDir}\04_tables"

********************************************************************************

use "$posted/3a_imputed_transitions_tertiary.dta", clear

*###############################################################################
* Educ on Mediator Knowledge
*###############################################################################

mi estimate, post: regress zknow i.edupar3, cluster(school)
estimates store know


*** ESTIMATES TABLE ***

	esttab know  ///
		using "$tables/tab3_regression_mediator.rtf", ///
		c(b(star fmt(2)) se(fmt(2))) ///
		star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 	///
		replace b(%8.3f) r2 label nobaselevels nodepvar ///
		title("") ///
		addnote("Source: VOCL 1993 cohort")
		
		
* Average Pseudo R2

	mi query	
	local M = r(M)	
	scalar r2 = 0
	quietly mi xeq 1/`M': regress zknow i.edupar3, cluster(school) ///
	; scalar r2 = r2 + e(r2)
		
	scalar r2 = r2/`M'
	di as txt "R2 over model knowledge = " as res r2
