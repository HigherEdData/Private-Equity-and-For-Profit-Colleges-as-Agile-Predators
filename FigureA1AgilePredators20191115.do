
**Figure A1: Tuition and debt by ownership over time
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

gen tuitionall_thousands = tuitionall_c_w / 1000
gen loan_amt_thousands = loan_amount_borrower_c_w / 1000

collapse (mean) tuitionall_thousands loan_amt_thousands grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w , ///
by(owner_pe year)

reshape wide tuitionall_thousands loan_amt_thousands grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w, i(year) j(owner_pe)

foreach var in tuitionall_thousands loan_amt_thousands grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w {
label var `var'1 "Private equity"
label var `var'2 "Publicly traded"
label var `var'3 "Privately Held"
label var `var'4 "Non-profit"
label var `var'5 "State"
label var `var'6 "Community"
}
*

tw (connect tuitionall_thousands* year, sort msym(O O O D D) ///
	mc(black black black gs8 gs8) ///
	mfc(black gs12 white gs12 white) ///
	lp(l l l l l) lc(black black black gs8 gs8) ///
	lw(medthick medthick medthin thin thin)) ///
	if year>=1989 & year<2016, ///
	legend(size(small) pos(3)  ///
	subtitle("{bf:Ownership}", size(small))) ///
	ytitle(Average tuition in thousands(2015$)) ///
	xsize(6.5) ysize(5) ///
	name(tuition_time, replace)

	tw (connect loan_amt_thousands* year, sort msym(O O O D D) ///
	mc(black black black gs8 gs8) ///
	mfc(black gs12 white gs12 white) ///
	lp(l l l l l) lc(black black black gs8 gs8) ///
	lw(medthick medthick medthin thin thin)) ///
	if year>=1999 & year<2016, ///
	legend(size(small) pos(3)  ///
	subtitle("{bf:Ownership}", size(small))) ///
	ytitle(Average loan in thousands(2015$)) ///
	xsize(6.5) ysize(5) ///
	name(loan_over_time, replace)

graph combine tuition_time loan_over_time, rows(2) scheme(plotplain) xsize(8.5) ysize(11)

graph export tuition_loan_time.png, replace
