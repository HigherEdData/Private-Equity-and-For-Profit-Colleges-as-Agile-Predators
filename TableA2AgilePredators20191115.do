
*Agile Predators Table A2
use "https://drive.google.com/uc?authuser=0&id=1GTIbi9C8ftL3a7mAg57vBSo21wLE1x87&export=download", clear

use "/Users/Charlie/Google Drive/replicationdata/agilepredatorsreplication20191115", clear

est clear

xtset unitid year

**Table LOANS * Excluding parent/child schools excludes 13 schools -- 8,357 vs. 8344 vs 8344 -- 10 of which are for-profits -  4479 vs. 4469
gen under_thousands=all_under_w/1000
xi: xtreg loan_amount_borrower_c_w peswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_sfa==., fe cluster(peswitchsystemall) noomitted

eststo est1
 
xi: xtreg loan_amount_borrower_c_w peswitcherall chain online under_thousands ///
 i.iclevel i.year i.state_n*year if idx_sfa==., fe cluster(peswitchsystemall) noomitted

eststo est2
  
xi: xtreg loan_amount_borrower_c_w peswitcherall chain online selective under_thousands dist_black dist_white dist_hisp fed_grant_pct_w ///
i.iclevel i.year i.state_n*year if idx_sfa==., fe cluster(peswitchsystemall) noomitted

eststo est3


**LOANS * Excluding parent/child schools excludes 13 schools -- 8,357 vs. 8344 vs 8344 -- 10 of which are for-profits -  4479 vs. 4469

xi: xtreg loan_amount_borrower_c_w poswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_sfa==., fe cluster(poswitchsystemall) noomitted

eststo est7
 
xi: xtreg loan_amount_borrower_c_w poswitcherall chain online under_thousands ///
 i.iclevel i.year i.state_n*year if idx_sfa==., fe cluster(poswitchsystemall) noomitted

eststo est8
  
xi: xtreg loan_amount_borrower_c_w poswitcherall chain online selective dist_black dist_white dist_hisp fed_grant_pct_w ///
under_thousands i.iclevel i.year i.state_n*year if idx_sfa==., fe cluster(poswitchsystemall) noomitted

eststo est9


esttab est1 est2 est3  ///
using "loanpefixedeffects.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(^ .1 * .05 ** .01 *** .001) ///
	keep (peswitcherall chain online under_thousands) replace

esttab est7 est8 est9 ///
using "loanpofixedeffects.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(r2_w N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(* .05 ** .01 *** .001) ///
	keep (poswitcherall chain online under_thousands) replace
	
