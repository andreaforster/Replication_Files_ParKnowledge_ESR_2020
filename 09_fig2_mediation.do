********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Mediation analysis of knowledge
********************************************************************************

* Description
/* This dofile carries out a khb mediation analysis with knowledge as the 
mediator. It produces the results presented in figure 2 in the paper*/

********************************************************************************

global dataDir "H:\Andrea\00_converted_data\VOCL93"
global workingDir "H:\Andrea\parental information\2021-04_replication_files"

global dofiles "${workingDir}\01_dofiles"
global posted "${workingDir}\02_posted"
global graphs "${workingDir}\03_graphs"
global tables "${workingDir}\04_tables"

********************************************************************************

use "$posted/3a_imputed_transitions_tertiary.dta", clear

********************************************************************************
* Upward Transitions
********************************************************************************

*-------------------------------------------------------------------------------
* KHB effect tables
*-------------------------------------------------------------------------------

preserve

	
*** Compare Model 1 and 2 ***

	mi estimate, cmdok: khb logit moveup i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school)
	
*** Compare Model 3 and 4 ***
	
	mi estimate, cmdok: khb logit moveup i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school)
		
restore 

*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 1+2 ***
*-------------------------------------------------------------------------------

	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if moveup !=.

*** auxiliary regressions (Z on X)

	scalar b2_model1 = 0
	scalar b3_model1 = 0
	
	quietly mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) /// 
		; scalar b2_model1 = b2_model1 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model1 = b3_model1 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model1 = b2_model1/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model1 // print average coefficient
		
	scalar b3_model1 = b3_model1/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model1 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	quietly mi estimate, post: logit moveup i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) 
	scalar b2_model2 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model2 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model2 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med12_sec = ///
		100*((b2_model1*know_model2)/(b2_model1*know_model2 + b2_model2))
	
	scalar perc_med12_tert = ///
		100*((b3_model1*know_model2)/(b3_model1*know_model2 + b3_model2))	

	scalar dir
restore


*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 3 + 4 ***
*-------------------------------------------------------------------------------
	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if moveup !=.

*** auxiliary regressions (Z on X)

	scalar b2_model3 = 0
	scalar b3_model3 = 0
	
	quietly mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) /// 
		; scalar b2_model3 = b2_model3 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model3 = b3_model3 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model3 = b2_model3/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model3 // print average coefficient
		
	scalar b3_model3 = b3_model3/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model3 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	quietly mi estimate, post: logit moveup i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) 
	scalar b2_model4 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model4 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model4 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med34_sec = ///
		100*((b2_model3*know_model4)/(b2_model3*know_model4 + b2_model4))
	
	scalar perc_med34_tert = ///
		100*((b3_model3*know_model4)/(b3_model3*know_model4 + b3_model4))	

	scalar dir
	scalar drop _all
restore

********************************************************************************
* Downward Transitions
********************************************************************************

*-------------------------------------------------------------------------------
* KHB effect tables
*-------------------------------------------------------------------------------

preserve

	
*** Compare Model 1 and 2 ***

	mi estimate, cmdok: khb logit movedown2 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school)
	
*** Compare Model 3 and 4 ***
	
	mi estimate, cmdok: khb logit movedown2 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school)
		
restore 

*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 1+2 ***
*-------------------------------------------------------------------------------

	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if movedown2 !=.

*** auxiliary regressions (Z on X)

	scalar b2_model1 = 0
	scalar b3_model1 = 0
	
	mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) /// 
		; scalar b2_model1 = b2_model1 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model1 = b3_model1 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model1 = b2_model1/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model1 // print average coefficient
		
	scalar b3_model1 = b3_model1/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model1 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	mi estimate, post: logit movedown2 i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) 
	scalar b2_model2 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model2 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model2 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med12_sec = ///
		100*((b2_model1*know_model2)/(b2_model1*know_model2 + b2_model2))
	
	scalar perc_med12_tert = ///
		100*((b3_model1*know_model2)/(b3_model1*know_model2 + b3_model2))	

	scalar dir
restore


*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 3 + 4 ***
*-------------------------------------------------------------------------------
	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if movedown2 !=.

*** auxiliary regressions (Z on X)

	scalar b2_model3 = 0
	scalar b3_model3 = 0
	
	mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) /// 
		; scalar b2_model3 = b2_model3 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model3 = b3_model3 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model3 = b2_model3/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model3 // print average coefficient
		
	scalar b3_model3 = b3_model3/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model3 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	mi estimate, post: logit movedown2 i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) 
	scalar b2_model4 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model4 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model4 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med34_sec = ///
		100*((b2_model3*know_model4)/(b2_model3*know_model4 + b2_model4))
	
	scalar perc_med34_tert = ///
		100*((b3_model3*know_model4)/(b3_model3*know_model4 + b3_model4))	

	scalar dir
	scalar drop _all
restore

********************************************************************************
* Track 11th Grade
********************************************************************************

use "$posted/3b_imputed_track5.dta", clear

*-------------------------------------------------------------------------------
* KHB effect tables
*-------------------------------------------------------------------------------

preserve

	
*** Compare Model 1 and 2 ***

	mi estimate, cmdok: khb logit havovwo5 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school)
	
*** Compare Model 3 and 4 ***
	
	mi estimate, cmdok: khb logit havovwo5 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school)
		
restore 

*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 1+2 ***
*-------------------------------------------------------------------------------

	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if havovwo5 !=.

*** auxiliary regressions (Z on X)

	scalar b2_model1 = 0
	scalar b3_model1 = 0
	
	quietly mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) /// 
		; scalar b2_model1 = b2_model1 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model1 = b3_model1 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model1 = b2_model1/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model1 // print average coefficient
		
	scalar b3_model1 = b3_model1/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model1 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	quietly mi estimate, post: logit havovwo5 i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) 
	scalar b2_model2 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model2 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model2 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med12_sec = ///
		100*((b2_model1*know_model2)/(b2_model1*know_model2 + b2_model2))
	
	scalar perc_med12_tert = ///
		100*((b3_model1*know_model2)/(b3_model1*know_model2 + b3_model2))	

	scalar dir
restore


*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 3 + 4 ***
*-------------------------------------------------------------------------------
	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if havovwo5 !=.

*** auxiliary regressions (Z on X)

	scalar b2_model3 = 0
	scalar b3_model3 = 0
	
	quietly mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) /// 
		; scalar b2_model3 = b2_model3 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model3 = b3_model3 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model3 = b2_model3/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model3 // print average coefficient
		
	scalar b3_model3 = b3_model3/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model3 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	quietly mi estimate, post: logit havovwo5 i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) 
	scalar b2_model4 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model4 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model4 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med34_sec = ///
		100*((b2_model3*know_model4)/(b2_model3*know_model4 + b2_model4))
	
	scalar perc_med34_tert = ///
		100*((b3_model3*know_model4)/(b3_model3*know_model4 + b3_model4))	

	scalar dir
	scalar drop _all
restore


********************************************************************************
* Tertiary Degree
********************************************************************************

use "$posted/3a_imputed_transitions_tertiary.dta", clear

*-------------------------------------------------------------------------------
* KHB effect tables
*-------------------------------------------------------------------------------

preserve

	
*** Compare Model 1 and 2 ***

	mi estimate, cmdok: khb ologit tertiary3 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid) ///
		cluster(school)
	
*** Compare Model 3 and 4 ***
	
	mi estimate, cmdok: khb ologit tertiary3 i.edupar3 || ///
		zknow ///
		, c(i.track3 zcito female i.ethnicity numkid ///
		zaspire logbooks zinvolvement zclosure) ///
		cluster(school)
		
restore 

*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 1+2 ***
*-------------------------------------------------------------------------------

	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if tertiary3 !=.

*** auxiliary regressions (Z on X)

	scalar b2_model1 = 0
	scalar b3_model1 = 0
	
	mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) /// 
		; scalar b2_model1 = b2_model1 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model1 = b3_model1 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model1 = b2_model1/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model1 // print average coefficient
		
	scalar b3_model1 = b3_model1/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model1 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	mi estimate, post: ologit tertiary3 i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		, cluster(school) 
	scalar b2_model2 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model2 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model2 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med12_sec = ///
		100*((b2_model1*know_model2)/(b2_model1*know_model2 + b2_model2))
	
	scalar perc_med12_tert = ///
		100*((b3_model1*know_model2)/(b3_model1*know_model2 + b3_model2))	

	scalar dir
restore


*-------------------------------------------------------------------------------
*** Mediation Percentages: Sum and Disentangle for model 3 + 4 ***
*-------------------------------------------------------------------------------
	/*
	To define the contribution of each mediating variable to the reduction 
	of the effect of SES, we residualize them in a rotating manner and add 
	them separately to a model that already contains all the other variables
	*/
	
preserve 

/* restrict to sample for Upward transitions as the residualization
part doesn't contain the DV that is already restricted */ 
keep if tertiary3 !=.

*** auxiliary regressions (Z on X)

	scalar b2_model3 = 0
	scalar b3_model3 = 0
	
	mi xeq 1/20: regress zknow i.edupar3 /// z-variable x-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) /// 
		; scalar b2_model3 = b2_model3 + _b[2.edupar] /// sum up coefficients for upper secondary educ.
		; scalar b3_model3 = b3_model3 + _b[3.edupar] // sum up coefficients for uppe tertiary educ.
		
	scalar b2_model3 = b2_model3/20 // divide by number of imputations
	di as txt "upper sec (zknow) = " as res b2_model3 // print average coefficient
		
	scalar b3_model3 = b3_model3/20 // divide by number of imputations
	di as txt "tertiary (zknow) = " as res b3_model3 // print average coefficient
	
restore

*** full model ( Y on Z and X) 
	mi estimate, post: ologit tertiary3 i.edupar3 /// y-variable x-variable
		zknow /// z-variable
		i.track3 zcito female i.ethnicity numkid /// concomitants
		zaspire logbooks zinvolvement zclosure /// other mechanisms
		, cluster(school) 
	scalar b2_model4 = _b[2.edupar] // take effect of x (direct effect)
	scalar b3_model4 = _b[3.edupar] // take effect of x (direct effect)
	scalar know_model4 = _b[zknow] // take effect of z

*** Calculate Percentages

preserve	
	scalar perc_med34_sec = ///
		100*((b2_model3*know_model4)/(b2_model3*know_model4 + b2_model4))
	
	scalar perc_med34_tert = ///
		100*((b3_model3*know_model4)/(b3_model3*know_model4 + b3_model4))	

	scalar dir
	scalar drop _all
restore