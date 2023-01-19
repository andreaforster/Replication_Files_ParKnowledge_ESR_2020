********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Coding of Variables
********************************************************************************

* Description
/* This dofile implements restrictions on the sample and prepares all the 
variables used in the analysis */

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


*###############################################################################
* sample cuts
*###############################################################################

use "$posted\1_merged.dta", clear
count 

/* I want to start with a homogeneous group, so students who are already delayed
or have skipped a class by year 3 (when the important variables for mechanisms
are measured) are deleted from the sample */

drop if klas95!=3
count 

********************************************************************************
/* Selection: We do not look at first generation immigrant children as their 
school career has not necessarily taken place in the Netherlands */
********************************************************************************

keep if gebkigba==1
count

********************************************************************************
* IDentifiers of whether a certain questionnaire/test was filled in
********************************************************************************

rename dumoud_1 w_parquest1
rename dumen_it w_cito1
rename dumlvr_1 w_childquest1

rename dumoud_3 w_parquest3
rename duned_it w_dutch3
rename duwis_it w_math3
rename dumlvr_3 w_childquest3


********************************************************************************
* Gender
********************************************************************************

* gender
recode gesl				///
	(1 = 0 "male")		///
	(2 = 1 "female")	///
	, gen(female)		
	
lab var female "Female"

********************************************************************************
* birthyear
********************************************************************************

/* use the GBAPERSOONSTAB Variable for birthyear as it is more detailed than 
the variable from VOCL */

* generate numeric variable from string
encode birthyear_prim_gba, gen(birthyear_gba) 

* recode to attach labels to values
recode birthyear_gba 	 ///
	(1 = 1 "1974")		///
	(2 = 2 "1976")		///
	(3 = 3 "1977")		///
	(4 = 4 "1978")		///
	(5 = 5 "1979")		///
	(6 = 6 "1980")		///
	(7 = 7 "1981")		///
	(8 = 8 "1982")		///
	, gen(birthyr)

lab var birthyr "Year of Birth"  	

* replace with VOCL variable if register variable is missing
replace birthyr = gebjr_nw if birthyr ==.

********************************************************************************
* Parental education
********************************************************************************


* 5 Categories of parental education

recode hooplv 								///
	(2 = 1 "Primary")						///
	(3 = 2 "Lower Secondary")				///
	(4 = 3 "Upper Secondary")				///
	(5 = 4 "Tertiary First Stage")			///
	(6 7 = 5 "Tertiary Second Stage")		///
	(else =.)								///
	, gen(edupar)

lab var edupar "Parental Education"

* reduce to 3 Categories of Parental Education, low, medium, high

recode edupar 								///
	(1 2=1 "Primary or lower Secondary") 	/// 
	(3=2 "Upper Secondary")					/// 
	(4 5 =3 "Tertiary")						/// 
	(else=.)								///
	, gen(edupar3)

lab var edupar3 "Parental Education (3 cat)"

********************************************************************************
* Social Class
********************************************************************************

recode socmil 								///
	(1=1 "working class")					///
	(2=2 "Self-employed w/o employees") 	///
	(3=3 "Self employed with employees")	///
	(4=4 "Lower non-manual")				///
	(5=5 "Intermediate occupations") 		///
	(6=6 "Higher occupations")				///
	(else=.)								///
	, gen(soc_class)
	
lab var soc_class "Parental Social Class"

********************************************************************************
* Parents' household income (from registers)
********************************************************************************

gen stdincome_fa = BVRBESTINKHpa/sqrt(BVRAHLpa)
gen stdincome_mo = BVRBESTINKHma/sqrt(BVRAHLma)

gen parinc = stdincome_mo
replace parinc = stdincome_fa if stdincome_mo==.

lab var parinc "Parental household income (2004)"

********************************************************************************
* Teacher's Track Advice
********************************************************************************

/* Track recommendation coded from 1 to 9 from low (ivbo, vbo) to high (vwo) */

rename advies advice

lab var advice "Track Recommendation"	

********************************************************************************
* Parental knowledge
********************************************************************************
/*

Text in the questionnaire: 
Voor ouders is het vaak moeilijk te overzien welke mogelijkheden er precies zijn voor
vervolgonderwijs. De volgende vraag gaat hierover. Steeds wordt gevraagd tot welke
vervolgopleiding iemand direct kan worden toegelaten met het aangegeven diploma.
Hierbij is steeds meer dan één antwoord mogelijk. U maakt onder elke opleiding
waarvan u denkt dat deze mogelijk is met het aangegeven diploma, het rondje zwart. Als
u het niet weet omcirkelt u het cijfer 9.”

There is a scale for knowledge (kennis) provided in the data. However, it is not
documented which items were used for this scale --> we construct our own scale
by summing up the correct answers over items

*/


/* Overall knowledge of the educational system */

gen know = v24a1 + v24a2 + v24a3 + v24a4 + v24a5 + v24a6 + ///
	v24b1 + v24b2 + v24b3 + v24b4 + v24b5 + v24b6 + v24c1 + ///
	v24c2 + v24c3 + v24c4 + v24c5 + v24c6 + ///
	v24d1 + v24d2 + v24d3 + v24d4 + v24d5 + v24d6

lab var know "Parents' Knowledge Educational System"

/* scales */

* Cronbach Alpha
alpha v24a1 v24a2 v24a3 v24a4 v24a5 v24a6 ///
	v24b1 v24b2 v24b3 v24b4 v24b5 v24b6 ///
	v24c1 v24c2 v24c3 v24c4 v24c5 v24c6 ///
	v24d1 v24d2 v24d3 v24d4 v24d5 v24d6
	
* Factor analysis
factor v24a1 v24a2 v24a3 v24a4 v24a5 v24a6 ///
	v24b1 v24b2 v24b3 v24b4 v24b5 v24b6 ///
	v24c1 v24c2 v24c3 v24c4 v24c5 v24c6 ///
	v24d1 v24d2 v24d3 v24d4 v24d5 v24d6, pcf

* those with high loading on factor 1 only:
gen know2 = v24a1 + v24a3 + v24b1 + v24b4 + v24c1 + v24c2 + v24c5 ///
	+ v24d1 + v24d2 + v24d6

/* Knowledge on lower tracks vs. Knowledge on higher tracks */

gen know_low = v24a1 + v24a2 + v24a3 + v24a4 + v24a5 + v24a6 + ///
	v24b1 + v24b2 + v24b3 + v24b4 + v24b5 + v24b6

lab var know_low "Knowledge on Lower Tracks (vbo, mavo)"	

gen know_high = v24c1 + v24c2 + v24c3 + v24c4 + v24c5 + v24c6 + ///
	v24d1 + v24d2 + v24d3 + v24d4 + v24d5 + v24d6

lab var know_high "Konwledge on Higher Tracks (havo, vwo)"	

	
*Standardize all knowledge variables
egen zknow_low = std(know_low)
lab var zknow_low "Knowledge Lower Tracks (z-score)"

egen zknow_high = std(know_high)
lab var zknow_high "Knowledge Higher Tracks (z-score)"

egen zknow = std(know)
lab var zknow "Knowledge (z-score)"

egen zknow2 = std(know2)

	
/* What to do with the "weet niet" ? They are separately coded but overlap with
the answers to the single items */

********************************************************************************
*  Test Score
********************************************************************************

* YEAR 1 Cito

recode cstotr (99=.), gen(cito)

lab var cito "Cito test"

egen zcito = std(cito)
lab var zcito "Cito test (z-score)"

* YEAR 3 Dutch

egen zdutch3 = std(totned)

lab var zdutch3 "Dutch Test in Year 3 (z-score)"

* Year 3 Math

/* There were two different tests administered as the performances in math
differed to a large extent and would have produced bottom and ceiling effects
if one test were used 

We still use both tests as one variable. The important question is whether
performance induces transitions and performance is also relative to the
track on is placed in
*/

* math test difficult version (mavo, havo, vwo)
egen zmathA = std(totwiska)

* math test easy version (vbo)
egen zmathB = std(totwiskb)

gen zmath3 = zmathA
	replace zmath3 = zmathB if zmathA==.
	
lab var zmath3 "Math Test in Year 3 (z-score)"

********************************************************************************
* Achievement motivation
********************************************************************************

egen zmotiv1 = std(presmo_1)

lab var zmotiv1 "Achievement motivation in Year 1 (z-score)"

egen zmotiv3 = std(presmo_3)

lab var zmotiv3 "Achievement motivation in Year 3 (z-score)"


********************************************************************************
* Ethnicity
********************************************************************************

gen etn=gebvrgba
	replace etn=gebmngba if (gebvrgba==1 & gebmngba!=1)

recode etn 					///
	(1=1 "Dutch")			///
	(2=2 "Moroccan")		///
	(3=3 "Surin/Antil") 	///
	(4=4 "Turkish")			///
	(5=5 "Other")			///
	(else =.)				///
	, gen(ethnicity)
	
	
lab var ethnicity "Ethnic Background"



********************************************************************************
* number of children in household
********************************************************************************

recode nkind_nw (.=.), gen(numkid)
lab var numkid "Children in Household"

********************************************************************************
* aspiration of parents
********************************************************************************

recode v23 (0 9=.), gen(aspire) 
lab var aspire "Parental Aspirations"

egen zaspire = std(aspire)
lab var zaspire "Parental Aspirations (z-score)"

********************************************************************************
* Cultural Capital (books at home)
********************************************************************************
recode v42c (0=1), gen(books)
lab var books "Books at home"

gen logbooks = ln(books)/ln(2)
lab var logbooks "Books at home (logged base 2)"

********************************************************************************
* Parental involvement 
********************************************************************************

/* talk about school with child */

alpha v20a v20b v20c, gen(involvement)

lab var involvement "Parental involvement"

egen zinvolvement = std(involvement)
lab var zinvolvement "Parental involvement (z-score)"

********************************************************************************
* Social Network of parents
********************************************************************************

rename netwerk network

lab var network "Social network of parents"

egen znetwork = std(network)
lab var znetwork "Social network (z-score)"

********************************************************************************
* Intergenerational Closure: Parental exchange
********************************************************************************

gen closure = v27a
	replace closure = . if v27a==0
	replace closure = 0 if v27==1

egen zclosure = std(closure)
lab var zclosure "Intergenerational Closure (z-score)"

********************************************************************************
* Educational level in the single years of the survey
********************************************************************************

*-------------------------------------------------------------------------------
* Placement in school year 1993/94 (year 1 of the survey)
*-------------------------------------------------------------------------------

recode ondel93 						///
	(10000=1 "IVBO") 				///
	(9000=2  "VBO")					///
	(8000=3  "AVO/VBO")				///
	(3100=4  "MAVO/VBO")			///
	(3000=5  "MAVO")				///
	(2100=6  "HAVO/HAVO/VBO") 		///
	(2200=7  "HAVO/MAVO")			///
	(2000=8  "HAVO")				///
	(1100=9  "VWO/HAVO/MAVO/VBO")	///
	(1200=10 "VWO/HAVO/MAVO")		///
	(1300=11 "VWO/HAVO")			///
	(1000=12 "VWO")					///
	(else =.) ///
	, gen(track1)
	
lab var track1 "Educational Level Year 1"


recode track1						///
	(1 2 3 		= 1 "vbo")			///
	(4 5   		= 2 "mavo")			///
	(6 7 8 		= 3 "havo")			///
	(9 10 11 12 = 4 "vwo")			///
	, gen(edutype93)
	
*-------------------------------------------------------------------------------
* Placement in school year 1994/95 (year 2 of the survey)
*-------------------------------------------------------------------------------

recode ondel94						///
	(0			  = 0 "left")		///
	(50 80 90 100 = 1 "vbo") 		///
	(30 31 		  = 2 "mavo")		/// 
	(20 21 22 	  = 3 "havo") 		///
	(10 11 12 13  = 4 "vwo")  		///
	(else 		  = .)				///
	, gen(edutype94)

/* 
Of those who are coded as "left" (vertrokken) only some really left the school
system, others went abroad. got sick, died or reasons why they left the sample
are unknown. Those students shouldn't be coded as drop outs (0) but as missing (.)
This is done by recoding verc9394 according to the reason for leaving
*/

replace edutype94 = . if verc9394==2 | verc9394==4 | verc9394==5 ///
	| verc9394==7 | verc9394==8

*-------------------------------------------------------------------------------
* Placement in school year 1995/96 (year 3 of the survey)
*-------------------------------------------------------------------------------

recode ondel95 						///
	(0			  = 0 "left")	    ///
	(50 80 90 100 = 1 "vbo") 		///
	(30 31 		  = 2 "mavo")		/// 
	(20 21 22 	  = 3 "havo") 		///
	(10 11 12 13  = 4 "vwo")  		///
	(else 		  = .)				///
	, gen(edutype95)

replace edutype95 = . if edutype94==. & verc9495==1

replace edutype95 = . if verc9495==2 | verc9495==4 | verc9495==5 ///
	| verc9495==7 | verc9495==8	| verc9495==11 | verc9495==12

*-------------------------------------------------------------------------------
* Placement in school year 1996/97 (year 4 of the survey)
*-------------------------------------------------------------------------------

recode ondel96 							///
	(0					  = 0 "left")	///
	(5000 8000 9000 10000 = 1 "vbo") 	///
	(3000 3100	  		  = 2 "mavo")	/// 
	(2000 2200	  		  = 3 "havo") 	///
	(1000 1300 			  = 4 "vwo")  	///
	(20000/51000		  = 5 "mbo")	///	
	(else 		  		  = .)			///
	, gen(edutype96)

replace edutype96 = . if edutype95==. & verc9596==1
replace edutype96 = . if verc9596==2 | verc9596==4 | verc9596==5 ///
	| verc9596==7 | verc9596==8	| verc9596==11 | verc9596==12

	
*-------------------------------------------------------------------------------
* Placement in school year 1997/98 (year 5 of the survey)
*-------------------------------------------------------------------------------

recode ondel97 								///
	(0					=0 "left")			///
	(1000				=4 "vwo")			///
	(2000				=3 "havo")			///
	(3000/3100			=2 "mavo") 			///
	(5000/10000			=1 "vbo")			///
	(20000/51000		=5 "mbo")			///
	(else				=.)					///
	, gen(edutype97)
	
replace edutype97 = . if edutype96==. & verc9697==1
replace edutype97 = . if verc9697==2 | verc9697==4 | verc9697==5 ///
	| verc9697==7 | verc9697==8	| verc9697==11 | verc9697==12

*-------------------------------------------------------------------------------
* Placement in school year 1998/99 (year 6 of the survey)
*-------------------------------------------------------------------------------

recode ondel98 								///
	(0					=0 "left")			///
	(1000				=4 "vwo")			///
	(2000				=3 "havo")			///
	(3000/3100			=2 "mavo") 			///
	(5000/10000			=1 "vbo")			///
	(20000/51000		=5 "mbo")			///
	(60000/67000		=6 "hbo")			///
	(else				=.)					///
	, gen(edutype98)	

replace edutype98 = . if edutype97==. & verc9798==1
replace edutype98 = . if verc9798==2 | verc9798==4 | verc9798==5 ///
	| verc9798==7 | verc9798==8	| verc9798==11 | verc9798==12
	
*-------------------------------------------------------------------------------
* Placement in school year 1999/00 (year 7 of the survey)
*-------------------------------------------------------------------------------

recode ondel99								///
	(0					=0 "left")			///
	(1000				=4 "vwo")			///
	(2000				=3 "havo")			///
	(3000/3100			=2 "mavo") 			///
	(5000 9000 10000	=1 "vbo")			///
	(20000/51000		=5 "mbo")			///
	(60000/67000		=6 "hbo")			///
	(70001/90000		=7 "wo")			///
	(else				=.)					///
	, gen(edutype99)	

replace edutype99 = . if edutype98==. & verc9899==1
replace edutype99 = . if verc9899==2 | verc9899==4 | verc9899==5 ///
	| verc9899==7 | verc9899==8	| verc9899==11 | verc9899==12
	
********************************************************************************
* Track in year 3 (1995/96) when knowledge is measured
********************************************************************************

/* 
We reduce the track information to 4 categories. Within each category, the school
type of the category name is the highest track of a broader track
VWO means that if the student is in a broader class type e.g. VWO-HAVO,
VWO is the highest track in this class i.e. the highest track reachable without
switching pathway 

We use the track in grade 3 of secondary school. For most students this is the 
grade in 1995. We allow students to be delayed by one year. If in 1995, they
were still in grade 2 but in 1996 they were in grade 3, we use the information 
from 1996
*/	
	
*-------------------------------------------------------------------------------
* Track in year 3 of the survey
*-------------------------------------------------------------------------------
	
gen track3 = edutype95

lab def edutype 0 "Drop-out" 1 "VBO" 2 "MAVO" 3 "HAVO" 4 "VWO"		
lab val track3 edutype
		
lab var track3 "Track in Year 3"

* Being in havo or vwo in year 3
recode track3 (0 1 2 = 0 "No") (3 4 = 1 "Yes"), gen(havovwo3)


********************************************************************************
* Track in year 5
********************************************************************************

gen track5 = edutype97

lab def edutype_track5 0 "Left School" 1 "VBO" 2 "MAVO" 3 "HAVO" 4 "VWO" 5 "MBO" 		
lab val track5 edutype_track5
	
lab var track5 "Track in Year 5 (5 cat)"

* Being in havovwo(no matter in which grade)
recode edutype96					///
	(4 3=1 "Yes")					///
	(0 1 2 5=0 "No")	 			///
	(else=.)						///
	, gen(havovwo4)
	
recode edutype97					///
	(4 3=1 "Yes")					///
	(0 1 2 5=0 "No")	 			///
	(else=.)						///
	, gen(havovwo5)
	
recode edutype98					///
	(4 3=1 "Yes")					///
	(0 1 2 5=0 "No")	 			///
	(else=.)						///
	, gen(havovwo6)

recode edutype99					///
	(4 3=1 "Yes")					///
	(0 1 2 5=0 "No")	 			///
	(else=.)						///
	, gen(havovwo7)

	
/* 
Move up is 1 if someone who was in VBO, MAVO, HAVO in 1995

I recode mbo to lower than havo, vwo --> a move from havo or vwo to mbo is counted 
as downward transition as hbo or wo could have been reached 
*/	

recode edutype95 (. 0 5 6 7 =-10), gen(edutype95_cut)
recode edutype96 (. 0 5 6 7 =-10), gen(edutype96_cut)
recode edutype97 (. 0 5 6 7 =-10), gen(edutype97_cut)
recode edutype98 (. 0 5 6 7 =-10), gen(edutype98_cut)
recode edutype99 (. 0 5 6 7 =-10), gen(edutype99_cut)

gen moveup = 0  if edutype95!=4	
	replace moveup = 1 if (					///
		edutype96_cut > edutype95_cut	|	///
		edutype97_cut > edutype95_cut 	|	///
		edutype98_cut > edutype95_cut 	|	///
		edutype99_cut > edutype95_cut )	&	///
	 	edutype95!=4 
	replace moveup =. if moveup==0 & ///
		edutype99==.
		
lab var moveup "Upward Transition"

/* Move down is 1 if someone moved down within 2 years
*/

recode edutype95 (5=2), gen(edutype95_cut2)
recode edutype96 (5=2), gen(edutype96_cut2)
recode edutype97 (5=2), gen(edutype97_cut2)

gen movedown = 1 if edutype95!=1
		replace movedown = 0 if edutype95!=1 & ///
			edutype97_cut2 >= edutype95
		replace movedown =. if edutype95!=1 & movedown!=1 & edutype97==.
		
lab var movedown "Downward Transition"

	gen movedown2 = 1
			replace movedown2 = 0 if edutype97_cut2 >= edutype95
			replace movedown2 =. if movedown2!=1 & edutype97==.
			
	lab var movedown2 "Downward Transition"

	
	gen movedown3 = 0 if edutype95!=1
		replace movedown3 =1 if edutype97_cut2 < edutype95 & edutype97!=0 & edutype95!=1
		replace movedown3=. if edutype97==.
		replace movedown3=. if edutype97==0
	
preserve
	keep movedown2 edutype97 srtnum rin

	save "$posted/robust_movedown.dta",replace
restore 

********************************************************************************
* Tertiary degree 
********************************************************************************

destring soi2006_completed, gen(soi_level)

gen hbo = 0
	replace hbo = 1 if soi_level==52
	
gen university = 0
	replace university = 1 if inrange(soi_level, 53, 70)


gen tertiary3 = 1
	replace tertiary3 = 1 if inrange(soi_level, 10, 51)
	replace tertiary3 = 2 if soi_level==52
	replace tertiary3 = 3 if inrange(soi_level, 53, 70)
	
lab var tertiary3 "Tertiary degree (3-cat)"


********************************************************************************
* Tertiary Enrollment (robustness check)
********************************************************************************

destring soi2006_enrolled, gen(soi_enrol)

gen enrol3 = .
	replace enrol3 = 1 if inrange(soi_enrol, 10, 43)
	replace enrol3 = 2 if inrange(soi_enrol, 51, 52)
	replace enrol3 = 3 if inrange(soi_enrol, 53, 70)
	
lab var enrol3 "Tertiary enrollment(3-cat)"


********************************************************************************
* school gpa for a subsample in year 5
********************************************************************************

rename mcijf_h gpa_havo

lab var gpa_havo "GPA havo year 5"
 
rename mcijf_v gpa_vwo
	
lab var gpa_vwo "GPA vwo year 5"

********************************************************************************
* identifiers
********************************************************************************

* schools

rename sbrin02 school

lab var school "School Identifier"

* persons
lab var rin "identification number"

lab var srtnum "type identification"

********************************************************************************
* Keep only relevant variables
********************************************************************************


keep female birthyr ethnicity numkid ///
	edupar edupar3 soc_class parinc ///
	zknow zknow2 zknow_low zknow_high ///
	zcito zdutch3 zmath3 zmotiv1 zmotiv3 gpa_havo gpa_vwo ///
	zaspire logbooks zinvolvement znetwork zclosure ///
	advice track3 track5 havovwo3 havovwo5 moveup movedown movedown2 ///
	hbo university tertiary3 enrol3  ///
	school rin srtnum ///
	w_parquest1 w_cito1 w_childquest1 w_parquest3 w_dutch3 w_math3 ///
	w_childquest3 

save "$posted/2_prepared.dta", replace
