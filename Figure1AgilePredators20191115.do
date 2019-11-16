
*Agile Predators Figure 1
use "https://drive.google.com/uc?authuser=0&id=1GTIbi9C8ftL3a7mAg57vBSo21wLE1x87&export=download", clear

*College panel
table year owner_pe, c(n all_under_w)

*Enrollment panel
table year owner_pe, c(sum all_under_w)

*Firm panel
drop if all_under_w==.
collapse (sum) all_under (first) systemnm inst_name_new owner_pe, by(systemid year)
label val owner_pe owner_pe

table year owner_pe, c(n all_under_w)
