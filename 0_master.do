********************************************************************************
* Paper: Parents' Knowledge of the Educational System
* Data: VOCL 1993
* This Dofile: Master do-file with all analyses carried out for the paper
********************************************************************************


* Description

/* This dofile summarizes all analyses including robustness checks that were 
carried out for the paper: ``Navigating Institutions: Parents' knowledge
of the educational system and students' success in education''*/


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
* Main analysis
********************************************************************************

do "$dofiles/01_dataprep+merge.do"
do "$dofiles/02_prepvar+samplecuts.do"
do "$dofiles/03_imputation.do"
do "$dofiles/04_imputation_diagnostics.do"
do "$dofiles/05_tab1_description.do"
do "$dofiles/06_tab2_regressionmodels.do"
do "$dofiles/07_tab3_separate_transitions.do"
do "$dofiles/08_tab4_regonmediators.do"
do "$dofiles/09_fig2_mediation.do"

********************************************************************************
* Robustness check: knowledge of low and high tracks
********************************************************************************

do "$dofiles/10_robust_know-high-low.do"

********************************************************************************
* Robustness check: List-wise deletion
********************************************************************************

do "$dofiles/10_robust_listwise.do"

********************************************************************************
* Robustness check: knowledge measure from PCA
********************************************************************************

do "$dofiles/10_robust_pca_knowledge.do"

********************************************************************************
* Robustness check: interaction with performance
********************************************************************************

do "$dofiles/10_robust_performance.do"












