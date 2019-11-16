

**Table A5: Graduation rates and changes in ownership form, schools excluded with parent-child reporting for Pell Grant awards control
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
gen grad_chrt_thousands = grtotltallgradchrt / 1000

xtset unitid year

xi: xtreg grad_rate_150_p_w peswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_gr==. & idx_f==., fe cluster(peswitchsystemall) noomitted

eststo est1
  
xi: xtreg grad_rate_150_p_w peswitcherall chain online selective grad_chrt_thousands ///
 i.iclevel i.year i.state_n*year if idx_gr==. & idx_f==., fe cluster(peswitchsystemall) noomitted

eststo est2
  
xi: xtreg grad_rate_150_p_w peswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_pell ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==. & idx_f==., fe cluster(peswitchsystemall) noomitted

eststo est3
 
xi: xtreg grad_rate_150_p_w poswitcherall ///
 i.iclevel i.year i.state_n*year if idx_gr==. & idx_f==., fe cluster(poswitchsystemall) noomitted

eststo est4
  
xi: xtreg grad_rate_150_p_w poswitcherall chain online selective grad_chrt_thousands ///
 i.iclevel i.year i.state_n*year if idx_gr==. & idx_f==., fe cluster(poswitchsystemall) noomitted

eststo est5
  
xi: xtreg grad_rate_150_p_w poswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_pell ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==. & idx_f==., fe cluster(poswitchsystemall) noomitted

eststo est6

esttab est1 est2 est3 est4 est5 est6  ///
using "grad_pell_parent_child_exclude.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(^ .1 * .05 ** .01 *** .001) ///
	keep (peswitcherall poswitcherall chain online grad_chrt_thousands) replace 
 
