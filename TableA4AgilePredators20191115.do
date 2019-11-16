

** Table A4: Loans and ownership form, schools excluded with parent-child reporting for cohort race-ethnicity share controls
clear all
insheet using "https://raw.githubusercontent.com/charlieeatonphd/agilepredators/master/agilepredatorsdata20191116.csv", comma clear

label define iclevel 1 "Four or more years" 2 "At least 2 but less than 4 years"
label define owner_pe 1 "Private equity" 2 "Publicly traded" 3 "Privately held" 4 "Non-profit" 5 "State" 6 "Community"
rename iclevel iclevel_s
encode iclevel_s, gen(iclevel) label(iclevel)
rename state_n state_s
encode state_s, gen(state_n)
rename owner_pe owner_pe_s
encode owner_pe_s, gen(owner_pe) label(owner_pe)

xtset unitid year

xi: xtreg loan_amount_borrower_c_w peswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_sfa==. & idx_ef==., fe cluster(peswitchsystemall) noomitted

eststo est1
 
xi: xtreg loan_amount_borrower_c_w peswitcherall chain online under_thousands ///
 i.iclevel i.year i.state_n*year if idx_sfa==. & idx_ef==., fe cluster(peswitchsystemall) noomitted

eststo est2
  
xi: xtreg loan_amount_borrower_c_w peswitcherall chain online selective dist_black dist_white dist_hisp fed_grant_pct_w ///
under_thousands i.iclevel i.year i.state_n*year if idx_sfa==. & idx_ef==., fe cluster(peswitchsystemall) noomitted

eststo est3

xi: xtreg loan_amount_borrower_c_w poswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_sfa==. & idx_ef==., fe cluster(poswitchsystemall) noomitted

eststo est4
 
xi: xtreg loan_amount_borrower_c_w poswitcherall chain online under_thousands ///
 i.iclevel i.year i.state_n*year if idx_sfa==. & idx_ef==., fe cluster(poswitchsystemall) noomitted

eststo est5
  
xi: xtreg loan_amount_borrower_c_w poswitcherall chain online selective dist_black dist_white dist_hisp fed_grant_pct_w ///
under_thousands i.iclevel i.year i.state_n*year if idx_sfa==. & idx_ef==., fe cluster(poswitchsystemall) noomitted

eststo est6

esttab est1 est2 est3 est4 est5 est6  ///
using "/Users/$name/Desktop/loansexcludeparentchildcontrols.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(^ .1 * .05 ** .01 *** .001) ///
	keep (peswitcherall poswitcherall chain online under_thousands) replace
