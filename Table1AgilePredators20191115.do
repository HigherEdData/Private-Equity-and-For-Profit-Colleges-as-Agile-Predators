
use "https://drive.google.com/uc?authuser=0&id=1GTIbi9C8ftL3a7mAg57vBSo21wLE1x87&export=download", clear

**Set your user name for global macro
global name "Charlie"
est clear

cd "/Users/Charlie/Google Drive/Lincoln Project/IPEDS Disaggregated/Data"

use  "IPEDS predators prepped 20180217.dta", clear

keep loan_amount_borrower_c_w tuitionall_c_w grad_rate_150_p_w ///
grad_rate_150_p2yr_w grad_rate_150_p4yr_w selective iclevel online ///
chain all_under_w dist_black_share_w dist_white_share_w ///
dist_hisp_share_w fed_grant_pct_w dist_pell_s year owner_pe ///
pctchrtgrbkaat_w pctchrtgrwhitt_w pctchrtgrhispt_w ///
pct2yrchrtgrbkaat_w pct2yrchrtgrhispt_w pct2yrchrtgrwhitt_w ///
pct4yrchrtgrbkaat_w pct4yrchrtgrhispt_w pct4yrchrtgrwhitt_w ///
peswitcherall poswitcherall poswitchsystemall peswitchsystemall ///
systemid inst_name_new systemnm systemid peacqu poacqu ///
investevent IPO unitid year state_n idx_sfa idx_gr pe_ind po_ind ///
not_pe_po grtotltchrt4yr grtotltchrt2yr grtotltallgradchrt

outsheet using "/Users/Charlie/Google Drive/2018-2012HigherEdFinancialization/Papers/Proprietary College Financialization/Paper/SER/Replication/agilepredatorsdata20191116.csv", replace

save "/Users/Charlie/Google Drive/replicationdata/agilepredatorsreplication20191115", replace

label var "

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
sd(mean) by(owner_pe) 

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
