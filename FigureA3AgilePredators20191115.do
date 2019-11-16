
**Figure A3: Graduation rates over time by degree level
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

collapse (mean) grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w , ///
by(owner_pe year)

reshape wide grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w, i(year) j(owner_pe)

foreach var in grad_rate_150_p_w grad_rate_150_p2yr_w grad_rate_150_p4yr_w {
label var `var'1 "Private equity"
label var `var'2 "Publicly traded"
label var `var'3 "Privately Held"
label var `var'4 "Non-profit"
label var `var'5 "State"
label var `var'6 "Community"
}
*

tw (connect grad_rate_150_p_w1 grad_rate_150_p_w2 grad_rate_150_p_w3 ///
	grad_rate_150_p_w4 grad_rate_150_p_w5 year, sort msym(O O O D D) ///
	mc(black black black gs8 gs8) ///
	mfc(black gs12 white gs12 white) ///
	lp(l l l l l) lc(black black black gs8 gs8) ///
	lw(medthick medthick medthin thin thin)) ///
	if year>1994 & year<2011, ///
	legend(size(small) pos(3) order(3 4 5 1 2) ///
	subtitle("{bf:Ownership}", size(small))) ///
	title(Graduation rate) ///
	xsize(6.5) ///
	name(grad_time, replace)

tw (connect grad_rate_150_p2yr_w1 grad_rate_150_p2yr_w2 grad_rate_150_p2yr_w3  ///
	grad_rate_150_p2yr_w4 year , sort msym(O O O D D) ///
	mc(black black black gs8 gs8)  ///
	mfc(black gs12 white gs12 white) ///
	lp(l l l l l) lc(black black black gs8 gs8) ///
	lw(medthick medthick medthin thin thin)) ///
	if year>1994 & year<2014, ///
	legend(size(small) pos(3) order(3 4 2 1) ///
	subtitle("{bf:Ownership}", size(small))) ///
	title(Less-than-4-year graduation rate) ///
	xsize(6.5) ///
	name(grad2yr_time, replace)

tw (connect grad_rate_150_p4yr_w1 grad_rate_150_p4yr_w2 grad_rate_150_p4yr_w3  ///
	grad_rate_150_p4yr_w4 grad_rate_150_p4yr_w5 year, sort msym(O O O D D) ///
	mc(black black black gs8 gs8) ///
	mfc(black gs12 white gs12 white) ///
	lp(l l l l l) lc(black black black gs8 gs8) ///
	lw(medthick medthick medthin thin thin)) ///
	if year>1994 & year<2011, ///
	legend(size(small) pos(3) order(4 5 3 2 1) ///
	subtitle("{bf:Ownership}", size(small))) ///
	title(4-year graduation rate) ///
	xsize(6.5) ///
	name(grad4yr_time, replace)

graph combine grad_time grad2yr_time grad4yr_time, rows(3) scheme(plotplain) xsize(8.5) ysize(11)

graph export grad_time_combined.png, replace
