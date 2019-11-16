
**Figure A2: ADJUSTED FIGURES FOR Tuition
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

**CREATE APPENDIX ADJUSTED FIGURES FOR Tuition**

xi i.state_n*year

quietly reg tuitionall_c_w i.owner_pe selective dist_black_share_w dist_white_share_w ///
dist_hisp_share_w dist_pell_s i.iclevel ///
i.year _Ista*, cluster(systemid) rob noomitted

margins i.owner_pe, atmeans

marginsplot, horizontal unique recast(scatter) scale(1.5) xsize(4.5) ysize(2.25) ///
title(Average tuition (2015$)) ytitle("") xtitle("") scheme(plotplain) ///
xlabel(0 "$0" 4000 "$4,000" 8000 "$8,000" 12000 "$12,000" 16000 "$16,000" 20000 "$20,000  ") ///
name(adjusted_tuition, replace)

graph export adjusted_tuition.png, replace
