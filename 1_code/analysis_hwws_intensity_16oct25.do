
* Does intensity of household promotion visits modify effectiveness of handwashing with soap and point-of-use water treatment interventions? Systematic re-review and meta-regression
* Intervention: handwashing with soap

**************************************************************************
************************   SETUP		    ******************************
**************************************************************************

		if c(os) == "Windows" {
		global github "C:/Users/`c(username)'/GitHub/WASH_intensity"
	}
	else if c(os) == "MacOSX" {
		global github "/Users/`c(username)'/Documents/GitHub/WASH_intensity"
	}

clear 
set varabbrev off

**************************************************************************
*/	primary analyses
			* exclude those with ≤1 HH visits
			* freq_prim and visnum_prim
**************************************************************************

qui {
clear
cd $github/2_input
use hwws_intensity

codebook freq_prim
drop if total_hh_visits == 0 | total_hh_visits == 1

cd $github/3_output/primary_hwws

	hist every_x_weeks, bin(8)
	graph export hist_hw_freq_prim.png, replace
	
	hist total_hh_visits, bin(8)
	graph export hist_hw_visnum.png, replace

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_prim.png, replace
	meta summ, subgroup(freq_prim) eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	putexcel set metareg_hw_prim.xlsx, sheet(example1) replace
	putexcel A1 = "HW ARI freq"
	putexcel A2 = `e(I2_res)'
	putexcel A3 = `e(p)' /// TECHNICALLY THIS IS P-VALUE FOR THE CHI-2 BUT IT'S THE SAME WHEN ONLY ONE COVARIATE

	matrix b = e(b)
	putexcel A6 = matrix(b), rownames nformat(number_d2)
		
	meta summ, eform(Risk ratios)
	putexcel A4 = `r(I2)'

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_prim.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'

	matrix b = e(b)
	putexcel A7 = matrix(b), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_visnum_prim.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)

	meta regress i.visnum_prim, random(dlaird)

	putexcel C1 = "HW ARI visnum"
	putexcel C2 = `e(I2_res)'
	putexcel C3 = `e(p)'

	matrix b = e(b)
	putexcel A8 = matrix(b), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel C4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_prim.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)

	meta regress i.visnum_prim, random(dlaird)

	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'

	matrix b = e(b)
	putexcel A9 = matrix(b), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}

**************************************************************************
**************************************************************************
*/	sensitivity analyses
**************************************************************************
**************************************************************************


*1. Include only "high-quality" studies (scoring 3 or more)
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwws_intensity
drop if total_hh_visits == 0 | total_hh_visits == 1

keep if quality >2 /// 5 dropped

cd $github/3_output/sensitivity_hwws/highqual

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_s1.png, replace
	meta summ, subgroup(freq_prim) eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hw_s1.xlsx, sheet(example1) replace
	putexcel A1 = "HW ARI freq"
	putexcel A2 = `e(I2_res)'
	putexcel A3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel A4 = `r(I2)'


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_s1.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	matrix output = r(table)
	
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_visnum_s1.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)

	meta regress i.visnum_prim, random(dlaird)
	matrix output = r(table)

	putexcel C1 = "HW ARI visnum"
	putexcel C2 = `e(I2_res)'
	putexcel C3 = `e(p)'
	putexcel N6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel C4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_s1.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)

	meta regress i.visnum_prim, random(dlaird)
	matrix output = r(table)

	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel T6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}

*2. Include interventions with ≤1 visits in "low" category, instead of excluding.
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwws_intensity

*this time exclude "drop if total_hh_visits == 0 | total_hh_visits == 1"

codebook freq_prim

cd $github/3_output/sensitivity_hwws/incl_01visit

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_s2.png, replace
	meta summ, subgroup(freq_prim) eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hw_s2.xlsx, sheet(example1) replace
	putexcel A1 = "HW ARI freq"
	putexcel A2 = `e(I2_res)'
	putexcel A3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel A4 = `r(I2)'


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_s2.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	matrix output = r(table)
	
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_visnum_s2.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)

	meta regress i.visnum_prim, random(dlaird)
	matrix output = r(table)

	putexcel C1 = "HW ARI visnum"
	putexcel C2 = `e(I2_res)'
	putexcel C3 = `e(p)'
	putexcel N6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel C4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_s2.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)

	meta regress i.visnum_prim, random(dlaird)
	matrix output = r(table)

	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel T6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'


}


*3. Alternative cut-off: (A) high = visits every 2 weeks or more frequently; (B) low-frequency = visits less frequently than every 2 weeks. 
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwws_intensity

drop if total_hh_visits == 0 | total_hh_visits == 1 /// 6 dropped

cd $github/3_output/sensitivity_hwws/alt_cut

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq1) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_s3.png, replace
	meta summ, subgroup(freq1) eform(Risk ratios)

	meta regress i.freq1, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hw_s3.xlsx, sheet(example1) replace
	putexcel A1 = "HW ARI freq"
	putexcel A2 = `e(I2_res)'
	putexcel A3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel A4 = `r(I2)'


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq1) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_sg1_s3.png, replace
	meta summ, subgroup(freq1)  eform(Risk ratios)

	meta regress i.freq1, random(dlaird)
	matrix output = r(table)
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum1) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_visnum_s3.png, replace
	meta summ, subgroup(visnum1)  eform(Risk ratios)

	meta regress i.visnum1, random(dlaird)
	matrix output = r(table)

	putexcel C1 = "HW ARI visnum"
	putexcel C2 = `e(I2_res)'
	putexcel C3 = `e(p)'
	putexcel N6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel C4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum1) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_s3.png, replace
	meta summ, subgroup(visnum1)  eform(Risk ratios)

	meta regress i.visnum1, random(dlaird)
	matrix output = r(table)

	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel T6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}


*4. Three levels: (A) high = visits every 1 week or more; (B) medium = visits every 2-4 weeks; (C) low = visits less than every 4 weeks).
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwws_intensity

drop if total_hh_visits == 0 | total_hh_visits == 1 /// 6 dropped

cd $github/3_output/sensitivity_hwws/3level

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq2) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_s4.png, replace
	meta summ, subgroup(freq2) eform(Risk ratios)

	putexcel set metareg_hw_s4.xlsx, sheet(example1) replace
		
	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel B17 = matrix(ES), rownames nformat(number_d2)
		
	meta regress i.freq2, random(dlaird)
	
	matrix output = r(table)
	putexcel A1 = "HW ARI freq"
	putexcel A2 = `e(I2_res)'
	putexcel A3 = `e(p)'
	putexcel A6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel A4 = `r(I2)'

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq2) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_sg1_s4.png, replace
	meta summ, subgroup(freq2)  eform(Risk ratios)

	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel B25 = matrix(ES), rownames nformat(number_d2)
	
	*alt method is to do this as 2 dummy vars (per Cochrane)
	*but gives same coeff and p-value: 
	*meta regress i.freq3lev_bin1 i.freq3lev_bin2, random(dlaird)
	
	meta regress i.freq2, random(dlaird)
	
	matrix output = r(table)
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel G6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum2) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_visnum_s4.png, replace
	meta summ, subgroup(visnum2)  eform(Risk ratios)

		matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel B33 = matrix(ES), rownames nformat(number_d2)

	
	meta regress i.visnum2, random(dlaird)

	matrix output = r(table)
	putexcel C1 = "HW ARI visnum"
	putexcel C2 = `e(I2_res)'
	putexcel C3 = `e(p)'
	putexcel M6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel C4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum2) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_s4.png, replace
	meta summ, subgroup(visnum2)  eform(Risk ratios)

		matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel B41 = matrix(ES), rownames nformat(number_d2)

	meta regress i.visnum2, random(dlaird)

	matrix output = r(table)
	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel S6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}


*5. Continuous var
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwws_intensity
cd $github/3_output/sensitivity_hwws/cont

drop if total_hh_visits == 0 | total_hh_visits == 1 /// 6 dropped

*scatter
	scatter ari_es every_x_weeks
	graph export scatter_HW_ari_ES_freq.png, replace
	
	scatter dd_es every_x_weeks
	graph export scatter_HW_DD_ES_freq.png, replace
	
	scatter ari_es total_hh_visits
	graph export scatter_HW_ari_ES_visnum.png, replace
	
	scatter dd_es total_hh_visits
	graph export scatter_HW_DD_ES_visnum.png, replace

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta regress every_x_weeks, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hwws_cont_freq.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

	
*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta regress every_x_weeks, random(dlaird)
	matrix output = r(table)
	
	putexcel D1 = "cont"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'
	
*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta regress total_hh_visits, random(dlaird)
	
	matrix output = r(table)
	
	putexcel set metareg_hwws_cont_visnum.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'
	
*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta regress total_hh_visits, random(dlaird)

	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta regress total_hh_visits, random(dlaird)
	matrix output = r(table)
	
	putexcel D1 = "cont"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'
		
}

*6. Leave one out
*//////////////////////////////////////////////////////////


clear
cd $github/2_input
use hwws_intensity
list study if total_hh_visits == 0 | total_hh_visits == 1
drop if total_hh_visits == 0 | total_hh_visits == 1 

gen id = _n
list study id
cd $github/3_output/sensitivity_hwws/leaveoneout

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	putexcel set metareg_hw_s6_arifreq.xlsx, sheet(example1) replace
	meta regress i.freq_prim, random(dlaird)	 
forvalues i = 1(1)17 {
	 preserve
	 drop if id == `i'
	 meta regress i.freq_prim, random(dlaird)	 
	 matrix output = r(table)
	 putexcel A`i' = `e(p)'
	 putexcel B`i' = matrix(output), rownames nformat(number_d2)
	 restore
	 } 
	list study id if ari_ln_es == .


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	putexcel set metareg_hw_s6_ddfreq.xlsx, sheet(example1) replace
forvalues i = 1(1)17 {
	 preserve
	 drop if id == `i'
	 meta regress i.freq_prim, random(dlaird)	 
	 matrix output = r(table)
	 putexcel A`i' = `e(p)'
	 putexcel B`i' = matrix(output), rownames nformat(number_d2)
	 restore
	 } 
	list study id if dd_ln_es == .

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	putexcel set metareg_hw_s6_arivisnum.xlsx, sheet(example1) replace
forvalues i = 1(1)17 {
	 preserve
	 drop if id == `i'
	 meta regress i.visnum_prim, random(dlaird)	 
	 matrix output = r(table)
	 putexcel A`i' = `e(p)'
	 putexcel B`i' = matrix(output), rownames nformat(number_d2)
	 restore
	 } 
	 list study id if ari_ln_es == .
	 
*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	putexcel set metareg_hw_s6_ddvisnum.xlsx, sheet(example1) replace
forvalues i = 1(1)17 {
	 preserve
	 drop if id == `i'
	 meta regress i.visnum_prim, random(dlaird)	 
	 matrix output = r(table)
	 putexcel A`i' = `e(p)'
	 putexcel B`i' = matrix(output), rownames nformat(number_d2)
	 restore
	 } 
	list study id if dd_ln_es == .

	

*7. Incl monitoring visits
*//////////////////////////////////////////////////////////


qui {
clear
cd $github/2_input
use hwws_intensity
list study if total_hh_visits == 0 | total_hh_visits == 1
drop if total_hh_visits == 0 | total_hh_visits == 1 

***studies which switched category when monitoring visits included
	*Hartinger 2016
	*Hashi 2017
	*Huda 2012
	*Manaseki-Holland 2021
	*Morse 2020
	*Opryszko 2010
	*Pickering 2015
	*Sinharoy 2017
	*Stanton 1988

****studies not included becuase total_hh_visits == 0 | total_hh_visits == 1
	*            Begum 2020
	*          Galiani 2015
	* Manaseki-Holland 2021
	*        Pickering 2015
	*         Sinharoy 2017
	*          Stanton 1988
	
cd $github/3_output/sensitivity_hwws/mon_visits

*ARI freq
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_mon) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_s7.png, replace
	meta summ, subgroup(freq_mon) eform(Risk ratios)

	meta regress i.freq_mon, random(dlaird)
	matrix output = r(table)
	putexcel set metareg_hw_s7.xlsx, sheet(example1) replace
	putexcel A1 = "HW ARI freq"
	putexcel A2 = `e(I2_res)'
	putexcel A3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel A4 = `r(I2)'


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_mon) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_s7.png, replace
	meta summ, subgroup(freq_mon)  eform(Risk ratios)

	meta regress i.freq_mon, random(dlaird)
	matrix output = r(table)
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*ARI visnum
	meta set ari_ln_es ari_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_mon) nullrefline esrefline eform(Risk ratios)
	graph export ari_metan_visnum_s7.png, replace
	meta summ, subgroup(visnum_mon)  eform(Risk ratios)

	meta regress i.visnum_mon, random(dlaird)
	matrix output = r(table)
	putexcel C1 = "HW ARI visnum"
	putexcel C2 = `e(I2_res)'
	putexcel C3 = `e(p)'
	putexcel N6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel C4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_mon) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_s7.png, replace
	meta summ, subgroup(visnum_mon)  eform(Risk ratios)

	meta regress i.visnum_mon, random(dlaird)
	matrix output = r(table)
	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel T6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}



graph close
clear

