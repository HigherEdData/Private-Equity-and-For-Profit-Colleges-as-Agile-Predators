
*Agile predators table 1 descriptives
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

label var loan_amount_borrower_c_w "Loan per borrower (2015$)"
label var tuitionall_c_w "Tuition (2015$)"
label var grad_rate_150_p_w "Graduation rate*"
label var grad_rate_150_p2yr_w "Graduation rate* (less than-4-year)"
label var grad_rate_150_p4yr_w "Graduation rate* (4-year)"
label var selective "Selective admissions"
label var iclevel "Highest degree offered**"
label var online "Online campus"
label var chain "Part of chain"
label var all_under_w "Undergrad enrollment"
label var dist_black_share_w "Share students Black"
label var dist_white_share_w "Share students Hispanic"
label var dist_hisp_share_w "Share students white"
label var fed_grant_pct "Share students with federal grants"
label var dist_pell_s "Pell grants per FTE undergrad (2015$)"

tabstat loan_amount_borrower_c_w tuitionall_c_w grad_rate_150_p_w ///
grad_rate_150_p2yr_w grad_rate_150_p4yr_w selective iclevel online ///
chain all_under_w dist_black_share_w dist_white_share_w ///
dist_hisp_share_w fed_grant_pct_w dist_pell_s, ///
s(mean) by(owner_pe)

tabstat loan_amount_borrower_c_w tuitionall_c_w grad_rate_150_p_w ///
grad_rate_150_p2yr_w grad_rate_150_p4yr_w selective iclevel online ///
chain all_under_w dist_black_share_w dist_white_share_w ///
dist_hisp_share_w fed_grant_pct_w dist_pell_s, ///
s(sd) by(owner_pe) 

est clear
levelsof owner_pe, loc(levs)
qui foreach v of loc levs {
 estpost summ loan_amount_borrower_c_w tuitionall_c_w grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w selective iclevel online chain     ///
 all_under dist_black_share_w dist_white_share_w ///
 dist_hisp_share_w fed_grant_pct_w dist_pell_s if owner_pe==`v'
 est sto CY`v'
 }
 
esttab * using "agile_descriptives_n.csv", label ///
cell(count (fmt(%5.0f)) mean (fmt(%9.3f)) sd(par fmt(%9.3f))) mti collabels(none) nonum noobs replace

esttab * using "agile_descriptives_no_n_ratios.csv", label ///
cell(mean (fmt(%9.2f)) sd(par fmt(%9.2f))) mti collabels(none) nonum noobs replace

esttab * using "agile_descriptives_no_n_amounts.csv", label ///
cell(mean (fmt(%9.0fc)) sd(par fmt(%9.0fc))) tab mti collabels(none) nonum noobs replace
