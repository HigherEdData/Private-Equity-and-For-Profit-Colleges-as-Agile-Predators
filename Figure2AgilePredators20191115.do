
*Figure 2 Agile Predators
clear all
insheet using "https://raw.githubusercontent.com/charlieeatonphd/agilepredators/master/agilepredatorsdata20191116.csv", comma clear

tabstat peacqu poacqu, s(n) by(year)

*Ownership changes via buyout
tabstat peacqu if investevent==1, s(n) by(year)

*Ownership changes via chain acquisitions
tabstat poacqu if ipo==year, s(n) by(year)

*Acquisitions of non-profits
tabstat peacqu poacqu if owner_pe[_n-1]~=3, s(n) by(year)
