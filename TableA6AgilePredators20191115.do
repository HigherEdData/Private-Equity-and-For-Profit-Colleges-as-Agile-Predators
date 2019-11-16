

**Table A6: Graduation Rates from 2000 forward only
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
 i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(peswitchsystemall) noomitted

eststo est1
  
xi: xtreg grad_rate_150_p_w peswitcherall chain online selective grad_chrt_thousands ///
 i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(peswitchsystemall) noomitted

eststo est2
  
xi: xtreg grad_rate_150_p_w peswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_pell ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(peswitchsystemall) noomitted

eststo est3

xi: xtreg grad_rate_150_p_w peswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_fed_grant_pct_w ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(peswitchsystemall) noomitted

eststo est4
 
xi: xtreg grad_rate_150_p_w poswitcherall  ///
 i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(poswitchsystemall) noomitted

eststo est5
  
xi: xtreg grad_rate_150_p_w poswitcherall chain online selective grad_chrt_thousands ///
 i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(poswitchsystemall) noomitted

eststo est6
  
xi: xtreg grad_rate_150_p_w poswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_pell ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(poswitchsystemall) noomitted

eststo est7

xi: xtreg grad_rate_150_p_w poswitcherall chain online selective pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w dist_fed_grant_pct_w ///
grad_chrt_thousands i.iclevel i.year i.state_n*year if idx_gr==. & year>1999, fe cluster(poswitchsystemall) noomitted

eststo est8

esttab est1 est2 est3 est4 est5 est6 est7 est8  ///
using "graduation_2000_onward.csv", cells(b(star fmt(3)) se(fmt(3))) stardetach  ///
	legend label varlabels(_cons Constant)  stats(N N_g, fmt(3 0 0) ///
	label(R-square Institution-years Institutions)) starlevels(^ .1 * .05 ** .01 *** .001) ///
	keep (peswitcherall poswitcherall chain online grad_chrt_thousands) replace 
 
