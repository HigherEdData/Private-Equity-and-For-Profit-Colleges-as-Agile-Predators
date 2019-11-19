
*Agile Predators Figure 1
clear all
insheet using "https://raw.githubusercontent.com/charlieeatonphd/agilepredators/master/agilepredatorsdata20191116.csv", comma clear

*College panel
table year owner_pe, c(n all_under_w)

*Enrollment panel
table year owner_pe, c(sum all_under_w)

*Firm panel
drop if all_under_w==.
collapse (sum) all_under (first) systemnm inst_name_new owner_pe, by(systemid year)

table year owner_pe, c(n all_under_w)
