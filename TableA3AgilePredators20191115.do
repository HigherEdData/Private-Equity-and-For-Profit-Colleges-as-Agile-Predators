
*Agile Predators Table A3
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

gen grad_chrt_thousands = grtotltallgradchrt / 1000
***Excluding parent/child schools excludes 6 schools -- 5,702 vs 5696 -- 2 of which are for-profits - 2,048 2,046 vs.
 
xi: xtreg grad_rate_150_p_w peswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_gr==., fe cluster(peswitchsystemall) noomitted

eststo est4
  
xi: xtreg grad_rate_150_p_w peswitcherall chain online selective grad_chrt_thousands ///
 i.iclevel i.year i.state_n*year if idx_gr==., fe cluster(peswitchsystemall) noomitted

eststo est5
  
xi: xtreg grad_rate_150_p_w peswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_pell ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==., fe cluster(peswitchsystemall) noomitted

eststo est6

***Excluding parent/child schools excludes 6 schools -- 5,702 vs 5696 -- 2 of which are for-profits - 2,048 2,046 vs.
 
xi: xtreg grad_rate_150_p_w poswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_gr==., fe cluster(peswitchsystemall) noomitted

eststo est10
  
xi: xtreg grad_rate_150_p_w poswitcherall chain online selective grad_chrt_thousands ///
 i.iclevel i.year i.state_n*year if idx_gr==., fe cluster(peswitchsystemall) noomitted

eststo est11
  
xi: xtreg grad_rate_150_p_w poswitcherall chain online grad_chrt_thousands selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_pell ///
i.iclevel i.year i.state_n*year if idx_gr==., fe cluster(peswitchsystemall) noomitted

eststo est12

esttab est4 est5 est6  ///
using "gradpefixedeffects.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(^ .1 * .05 ** .01 *** .001) ///
	keep (peswitcherall chain online grad_chrt_thousands) replace

esttab est10 est11 est12 ///
using "gradpofixedeffects.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(r2_w N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(* .05 ** .01 *** .001) ///
	keep (poswitcherall chain online grad_chrt_thousands) replace
	
