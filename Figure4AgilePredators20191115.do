
*Agile Predators Figure 4
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

foreach var in loan_thousands {
foreach o in pe po {
use "https://drive.google.com/uc?authuser=0&id=1GTIbi9C8ftL3a7mAg57vBSo21wLE1x87&export=download", clear
gen loan_thousands = loan_amount_borrower_c_w / 1000
label var loan_thousands "Average loan in thousands (2015$)"
sort unitid year

by unitid: gen switch=year-1 if `o'_ind==1&not_pe_po[_n-1]==1&unitid==unitid[_n-1]&`var'~=.&`var'[_n-1]~=.
by unitid: egen switchall=min(switch)
gen switchdif=year-switchall
replace switchdif=5 if switchdif~=. & switchdif>4
replace switchdif=-5 if switchdif<-4
replace switchdif=0 if switchdif==.
replace switchdif=switchdif+6

gen switchsystem=systemid if switchdif==1
by unitid: egen switchsystemall=min(switchsystem)
by unitid: egen systemmode=mode(systemid)
replace switchsystemall=systemmode if switchsystemall==.

xtset unitid year
xtreg `var' ib6.switchdif i.iclevel i.year, fe cluster(switchsystemall)

gen coeff=.
gen se=.
gen n=_n

foreach i in 1 2 3 4 5 7 8 9 10 11 {
replace coeff=_b[`i'.switchdif] if n==`i'
replace se=_se[`i'.switchdif] if n==`i'
}

replace n=n-6

sort n

replace coeff=0 if n==0
replace se=0 if n==0

gen se1=coeff+1.96*se
gen se2=coeff-1.96*se

graph twoway (scatter coeff n if n<6, xlabel(-5 (1) 5) ylabel(-1 (1) 3) ysc(range(-1 3.2)) xline(0) title(`: variable label `var'') name(`o'`var', replace) ) ///
 (line coeff se1 se2 n if n<6, scheme(plotplain) ylabel(,grid)  xtitle("Years from change to `: variable label `o'_ind'") ///
 legend(off) lcolor(grey grey grey) lwidth(medium) lpattern(solid dash dash))

drop coeff se se1 se2 n switchsystem systemmode switchsystemall switchall switch switchdif

}
}

/*use "IPEDS predators prepped 20180217.dta", clear

drop if grad_rate_150_p_w==.
label var grad_rate_150_p_w "Graduation rate"
*/
foreach var in grad_rate_150_p_w {
foreach o in pe po {
use "https://drive.google.com/uc?authuser=0&id=1GTIbi9C8ftL3a7mAg57vBSo21wLE1x87&export=download", clear
drop if grad_rate_150_p_w==.
label var grad_rate_150_p_w "Graduation rate"
sort unitid year

by unitid: gen switch=year-1 if `o'_ind==1&not_pe_po[_n-1]==1&unitid==unitid[_n-1]&`var'~=.&`var'[_n-1]~=.
by unitid: egen switchall=min(switch)
gen switchdif=year-switchall
replace switchdif=5 if switchdif~=. & switchdif>4
replace switchdif=-5 if switchdif<-4
replace switchdif=0 if switchdif==.
replace switchdif=switchdif+6

gen switchsystem=systemid if switchdif==1
by unitid: egen switchsystemall=min(switchsystem)
by unitid: egen systemmode=mode(systemid)
replace switchsystemall=systemmode if switchsystemall==.

xtset unitid year
xtreg `var' ib5.switchdif i.iclevel i.year, fe cluster(switchsystemall)
*reghdfe `var' ib5.switchdif i.iclevel, absorb(unitid year) cluster(systemid year)

gen coeff=.
gen se=.
gen n=_n

foreach i in 1 2 3 4 6 7 8 9 10 11 {
replace coeff=_b[`i'.switchdif] if n==`i'
replace se=_se[`i'.switchdif] if n==`i'
}

replace n=n-6

sort n

replace coeff=0 if n==-1
replace se=0 if n==-1

gen se1=coeff+1.96*se
gen se2=coeff-1.96*se

graph twoway (scatter coeff n if n<6, xlabel(-5 (1) 5)  ylabel(-.2 (.1) .1) ysc(range(-.2 .1)) xline(-1) title(`: variable label `var'') name(`o'`var', replace))  ///
 (line coeff se1 se2 n if n<6, scheme(plotplain) ylabel(,grid)  xtitle("Years from change to `: variable label `o'_ind'") ///
 legend(off) lcolor(grey grey grey)  lwidth(medium) lpattern(solid dash dash))

drop coeff se se1 se2 n switchsystem systemmode switchsystemall switchall switch switchdif

}
}

graph combine peloan_thousands poloan_thousands pegrad_rate_150_p_w pograd_rate_150_p_w, ///
rows(3) scheme(plotplain) xsize(8.5) ysize(7)

graph export "loan_gradevents20180211.png", replace
