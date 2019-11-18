
*Agile Predators Figure 3
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

xi i.state_n*year

*Panel 1
quietly reg loan_amount_borrower_c_w i.owner_pe selective dist_black_share_w dist_white_share_w ///
dist_hisp_share_w fed_grant_pct_w i.iclevel ///
i.year _Ista* if idx_sfa==., cluster(systemid) rob noomitted

margins i.owner_pe, atmeans

marginsplot, horizontal unique recast(scatter) scale(1.5) xsize(4.5) ysize(2.25) ///
title(Average loan (2015$)) ytitle("") xtitle("") scheme(plotplain) ///
xlabel(4000 "$4,000" 5000 "$5,000" 6000 "$6,000" 7000 "$7,000" 8000 "$8,000" 9000 "$9,000") ///
name(adjusted_loan, replace)

*Panel 2
quietly reg grad_rate_150_p2yr_w i.owner_pe selective pct2yrchrtgrbkaat_w pct2yrchrtgrhispt_w pct2yrchrtgrwhitt_w ///
dist_pell_s i.iclevel ///
i.year _Ista* if owner_pe<5 & idx_gr==., cluster(systemid) rob noomitted

margins i.owner_pe, atmeans

marginsplot, horizontal unique recast(scatter) scale(1.5) xsize(4.5) ysize(2.25) ///
title(Less than 4-year graduation rate) ytitle("") xtitle("") scheme(plotplain) xlabel(.2(.1).7) ///
name(adjusted_grad_rate2yr, replace)

*Panel 3
quietly reg grad_rate_150_p4yr_w i.owner_pe selective pct4yrchrtgrbkaat_w pct4yrchrtgrhispt_w pct4yrchrtgrwhitt_w ///
dist_pell_s i.iclevel ///
i.year _Ista* if owner_pe~=6 & idx_gr==., cluster(systemid) rob noomitted

margins i.owner_pe, atmeans

marginsplot, horizontal unique recast(scatter) scale(1.5) xsize(4.5) ysize(2.25) ///
title(4-year graduation rate) ytitle("") xtitle("") scheme(plotplain) xlabel(.2(.1).7) ///
name(adjusted_grad_rate4yr, replace)

est clear
levelsof owner_pe_switch, loc(levs)
qui foreach v of loc levs {
 estpost summ grad_rate_150_p4yr_w if owner_pe_switch==`v'
 est sto CY`v'
 }
esttab *, cell(mean (fmt(%9.3f)))

graph combine adjusted_loan adjusted_grad_rate2yr adjusted_grad_rate4yr, rows(3) scheme(plotplain) xsize(8.5) ysize(11)

graph export adjusted_loan_grad.png, replace
