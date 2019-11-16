
*Figure 2 Agile Predators
use "https://drive.google.com/uc?authuser=0&id=1GTIbi9C8ftL3a7mAg57vBSo21wLE1x87&export=download", clear

tabstat peacqu poacqu, s(n) by(year)

*Ownership changes via buyout
tabstat peacqu if investevent==1, s(n) by(year)

*Ownership changes via chain acquisitions
tabstat poacqu if IPO==year, s(n) by(year)

*Acquisitions of non-profits
tabstat peacqu poacqu if owner_pe[_n-1]~=3, s(n) by(year)
