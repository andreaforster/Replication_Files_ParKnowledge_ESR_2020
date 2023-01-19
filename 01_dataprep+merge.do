********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Merging and Preparation of Data File
********************************************************************************

* Description
/* We use the main student file of the VOCL 1993 and merge it with information
from the parent questionnaire and information on higher education degrees from
the Dutch population registers */

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
* use VOCL 1993 main student data file
********************************************************************************

use "$dataDir\090324 VOCL hoofdbestand 1993V2.dta", clear
count

/* we cannot keep cases without identifier as we cannot merge these cases to other
data we need. We drop all students without "rin" */

drop if rin==.
count

********************************************************************************
* Merge VOCL parental data year 1 to data set
********************************************************************************

preserve

use "$dataDir\090324 VOCL ouderbestandlj1 1993V2.dta", clear

* we can only use cases with rin identifier and drop those without
drop if rin==.
save "$posted\ouderbestandj1", replace

restore

merge 1:1 srtnum rin using "$posted\ouderbestandj1.dta" ///
	, keep(match master) nogen
	
********************************************************************************
* Merge VOCL parental data year 3 to data set
********************************************************************************

preserve

use "$dataDir\090324 VOCL ouderbestandlj3 1993V2.dta", clear

* we can only use cases with rin identifier and drop those without
drop if rin==.
save "$posted\ouderbestandj3", replace

restore

merge 1:1 srtnum rin using "$posted\ouderbestandj3.dta" ///
	, keep(match master) nogen

********************************************************************************	
* Merge Data on further School Careers of Respondents
********************************************************************************

preserve

use "$dataDir\131121 VOCL schoolelementen 1993-2012V1.dta", clear

/* this data set has a different identifier name "rinpersoon". 
We again drop missings  */

drop if rinpersoon==.

gen rinpersoon2 = string(rinpersoon, "%09.0f")
drop rinpersoon
rename rinpersoon2 rinpersoon
save "$posted\schoolelementen2012", replace
restore

* we create a matching identifier in the main dataset to merge the school careers
gen rinpersoon = string(rin, "%09.0f")
clonevar rinpersoons=srtnum

merge 1:1 rinpersoon rinpersoons using "$posted\schoolelementen2012.dta" ///
	, keep(match master) nogen force 

********************************************************************************
* Merge testscores year 3 to data set
********************************************************************************

* Dutch Test
preserve

use "$dataDir\1993ToetsNederlandsV4CBKV1.dta", clear
rename RINPERSOON rinpersoon
rename RINPERSOONS rinpersoons
drop if rinpersoons=="G"
save "$posted\test_dutch_y3.dta", replace

restore

merge 1:1 rinpersoon rinpersoons using "$posted\test_dutch_y3.dta", ///
	keep(match master) nogen 
	
* Math Test
preserve

use "$dataDir\1993ToetsWiskundeV4CBKV1.dta", clear
rename RINPERSOON rinpersoon
rename RINPERSOONS rinpersoons
drop if rinpersoons=="G"
save "$posted\test_math_y3.dta", replace

restore

merge 1:1 rinpersoon rinpersoons using "$posted\test_math_y3.dta", ///
	keep(match master) nogen 

********************************************************************************
* Merge Information on Higher Education Degree from the Registers
********************************************************************************

merge 1:1 rinpersoon rinpersoons ///
	using "G:\Onderwijs\HOOGSTEOPLTAB\2015\geconverteerde data\HOOGSTEOPL2015TABV2.DTA" ///
	, keep(match master) nogen

********************************************************************************
* merge reference data for the study programme numbers from the register. 
* This is needed to decode the higher education degree from the previous data
********************************************************************************
clonevar oplnr = oplnrhb
merge m:1 oplnr using "$dataDir\oplref.dta" ///
	, keep(match master) nogen keepusing(SOI2006NIVEAU)
	
rename SOI2006NIVEAU soi2006_completed

drop oplnr

********************************************************************************
* merge reference data for the study programme numbers from the register. 
* This is needed to decode the higher education degree from the previous data
********************************************************************************
clonevar oplnr = oplnrhg
merge m:1 oplnr using "$dataDir\oplref.dta" ///
	, keep(match master) nogen keepusing(SOI2006NIVEAU)

rename SOI2006NIVEAU soi2006_enrolled
drop oplnr
	
********************************************************************************
* Merge register (GBA) birthyear of the students
********************************************************************************

merge 1:1 rinpersoon rinpersoons ///
using "G:\Bevolking\GBAPERSOONTAB\2016\geconverteerde data\GBAPERSOONTAB 2016V1.dta" ///
	, keep(match master) nogen 

rename gbageboortejaar birthyear_prim_gba
rename gbageboortemaand birthmonth_prim_gba
rename gbageboorteland birthcountry_prim_gba
rename gbageboortelandmoeder birthcountry_mo_gba
rename gbageboortelandvader birthcountry_fa_gba
rename gbaaantaloudersbuitenland foreignborn_par_gba

drop gbaherkomstgroepering gbageneratie gbageboortedag gbageslachtmoeder ///
	gbageslachtvader gbageboortejaarmoeder gbageboortemaandmoeder ///
	gbageboortedagmoeder gbageboortejaarvader gbageboortemaandvader ///
	gbageboortedagvader 
	
	
********************************************************************************	
* Merge parents' household income from registers
********************************************************************************

* merge VOCL students to their parents
merge 1:1 rinpersoon rinpersoons ///
	using "G:\Bevolking\KINDOUDERTAB\2014\geconverteerde data\KINDOUDERTAB 2014V1.dta" ///
	, keep(match master) nogen

rename rinpersoon rinpersoon_prim
rename rinpersoons rinpersoons_prim

preserve 

drop if RINPERSOONMa =="---------" 
drop if RINPERSOONMa ==""

rename RINPERSOONMa rinpersoon
rename RINPERSOONSMa rinpersoons

merge m:1 rinpersoon rinpersoons ///
	using "$dataDir\Koppeltabel_IPI_IHI_IVB2004V2.dta" ///
	, keep(match master) nogen

keep rinpersoon rinpersoons rinpersoonkern rinpersoonskern

rename rinpersoonkern RINPERSOONKERN 
rename rinpersoonskern RINPERSOONSKERN

merge m:1 RINPERSOONKERN RINPERSOONSKERN ///
	using "$dataDir\HUISHBVRINK2004TABV3.dta" ///
	, keep(match master) nogen

keep rinpersoons rinpersoon RINPERSOONSKERN RINPERSOONKERN BVRAHL BVRBESTINKH

rename rinpersoons RINPERSOONSMa
rename rinpersoon RINPERSOONMa
rename RINPERSOONSKERN rinpersoonskernma
rename RINPERSOONKERN rinpersoonkernma
rename BVRAHL BVRAHLma
rename BVRBESTINKH BVRBESTINKHma

drop if BVRBESTINKHma ==.
drop if BVRBESTINKHma ==999999999

save "$posted/household_income_mother.dta", replace
	
restore

preserve 

drop if RINPERSOONpa =="---------" 
drop if RINPERSOONpa ==""

rename RINPERSOONpa rinpersoon
rename RINPERSOONSpa rinpersoons

merge m:1 rinpersoon rinpersoons ///
	using "$dataDir\Koppeltabel_IPI_IHI_IVB2004V2.dta" ///
	, keep(match master) nogen

keep rinpersoon rinpersoons rinpersoonkern rinpersoonskern

rename rinpersoonkern RINPERSOONKERN 
rename rinpersoonskern RINPERSOONSKERN

merge m:1 RINPERSOONKERN RINPERSOONSKERN ///
	using "$dataDir\HUISHBVRINK2004TABV3.dta" ///
	, keep(match master) nogen

keep rinpersoons rinpersoon RINPERSOONSKERN RINPERSOONKERN BVRAHL BVRBESTINKH

rename rinpersoons RINPERSOONSpa
rename rinpersoon RINPERSOONpa
rename RINPERSOONSKERN rinpersoonskernpa
rename RINPERSOONKERN rinpersoonkernpa
rename BVRAHL BVRAHLpa
rename BVRBESTINKH BVRBESTINKHpa

drop if BVRBESTINKHpa ==.
drop if BVRBESTINKHpa ==999999999

save "$posted/household_income_father.dta", replace

restore


merge m:m RINPERSOONSpa RINPERSOONpa ///
	using "$posted/household_income_father.dta", keep(match master) nogen

merge m:m RINPERSOONSMa RINPERSOONMa ///
	using "$posted/household_income_mother.dta", keep(match master) nogen
	
save "$posted\1_merged.dta", replace



