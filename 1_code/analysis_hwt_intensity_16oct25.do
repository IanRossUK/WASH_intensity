
* Does intensity of household promotion visits modify effectiveness of handwashing with soap and point-of-use water treatment interventions? Systematic re-review and meta-regression
* Intervention: HWT chlorination

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
use hwt_intensity

codebook freq_prim
drop if total_hh_visits == 0 | total_hh_visits == 1

codebook freq_prim

keep if int_type == "chlorination"

cd $github/3_output/primary_hwt

	hist every_x_weeks, bin(8) xscale(range(0 8))
	graph export hist_chlo_freq_prim.png, replace
	
	hist total_hh_visits, bin(8) xscale(range(0 100))
	graph export hist_chlo_visnum.png, replace

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_hwt_metan_prim.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)
	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel set metareg_hwt_prim.xlsx, sheet(example1) replace
	putexcel B10 = matrix(ES), rownames nformat(number_d2)
		
	meta regress i.freq_prim, random(dlaird)
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'

	matrix b = e(b)
	putexcel B6 = matrix(b), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

	
	
*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_hwt_metan_visnum.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)
	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel H10 = matrix(ES), rownames nformat(number_d2)
	
	meta regress i.visnum_prim, random(dlaird)

	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'

	matrix b = e(b)
	putexcel B7 = matrix(b), rownames nformat(number_d2)

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
use hwt_intensity
drop if total_hh_visits == 0 | total_hh_visits == 1

keep if quality >2

keep if int_type == "chlorination"

cd $github/3_output/sensitivity_hwt/highqual

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_s1.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hwt_s1.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

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
	putexcel H6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}

*2. Include interventions with ≤1 visits in "low" category, instead of excluding.
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwt_intensity

keep if int_type == "chlorination"

cd $github/3_output/sensitivity_hwt/incl_01visit

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_s2.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)

	meta regress i.freq_prim, random(dlaird)
	matrix output = r(table)
	putexcel set metareg_hwt_s2.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

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
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'


}


*3. Alternative cut-off: (A) high = visits every 2 weeks or more frequently; (B) low-frequency = visits less frequently than every 2 weeks. 
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwt_intensity

drop if total_hh_visits == 0 | total_hh_visits == 1

keep if int_type == "chlorination"

cd $github/3_output/sensitivity_hwt/alt_cut

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq1) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_sg1_s3.png, replace
	meta summ, subgroup(freq1)  eform(Risk ratios)

	meta regress i.freq1, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hwt_s3.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

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
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}


*4. Three levels: (A) high = visits every 1 week or more; (B) medium = visits every 2-4 weeks; (C) low = visits less than every 4 weeks).
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwt_intensity

drop if total_hh_visits == 0 | total_hh_visits == 1

keep if int_type == "chlorination"

cd $github/3_output/sensitivity_hwt/3level

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq2) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_sg1_s4.png, replace
	meta summ, subgroup(freq2)  eform(Risk ratios)

	putexcel set metareg_hwt_s4.xlsx, sheet(example1) replace
	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel B17 = matrix(ES), rownames nformat(number_d2)
	
	meta regress i.freq2, random(dlaird)
	
	*meta regress i.freq3lev_bin1 i.freq3lev_bin2, random(dlaird)
	*doing it as 2 dummy vars (Cochrane) gives same coeff and p-value.
	
	matrix output = r(table)
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(visnum2) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_visnum_s4.png, replace
	meta summ, subgroup(visnum2)  eform(Risk ratios)

	matrix ES = r(esgroup)
	putexcel H17 = matrix(ES), rownames nformat(number_d2)

	
	meta regress i.visnum2, random(dlaird)

	matrix output = r(table)
	putexcel D1 = "HW DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}

*5. Continuous var
*//////////////////////////////////////////////////////////

qui {
clear
cd $github/2_input
use hwt_intensity
cd $github/3_output/sensitivity_hwt/cont

keep if int_type == "chlorination"

drop if total_hh_visits == 0 | total_hh_visits == 1

*scatter
	scatter dd_rr every_x_weeks
	graph export scatter_chlo_DD_ES_freq.png, replace

	scatter dd_rr total_hh_visits
	graph export scatter_chlo_DD_ES_visnum.png, replace


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta regress every_x_weeks, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hwt_cont.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)

	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'
	
*DD visnum
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
use hwt_intensity

keep if int_type == "chlorination"

list study if total_hh_visits == 0 | total_hh_visits == 1
drop if total_hh_visits == 0 | total_hh_visits == 1 

gen id = _n
list study id
cd $github/3_output/sensitivity_hwt/leaveoneout

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	putexcel set metareg_hwt_s6_ddfreq.xlsx, sheet(example1) replace
forvalues i = 1(1)18 {
	 preserve
	 drop if id == `i'
	 meta regress i.freq_prim, random(dlaird)	 
	 matrix output = r(table)
	 putexcel A`i' = `e(p)'
	 putexcel B`i' = matrix(output), rownames nformat(number_d2)
	 restore
	 } 
	list study id if dd_ln_es == .


*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	putexcel set metareg_hwt_s6_ddvisnum.xlsx, sheet(example1) replace
forvalues i = 1(1)18 {
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
use hwt_intensity

drop if total_hh_visits == 0 | total_hh_visits == 1

keep if int_type == "chlorination"

cd $github/3_output/sensitivity_hwt/mon_visits

*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study)
	meta forestplot, subgroup(freq_mon) nullrefline esrefline eform(Risk ratios)
	graph export dd_metan_sg1_s7.png, replace
	meta summ, subgroup(freq_mon)  eform(Risk ratios)

	meta regress i.freq_mon, random(dlaird)
	matrix output = r(table)
	
	putexcel set metareg_hwt_s7.xlsx, sheet(example1) replace
	putexcel B1 = "HW DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'
	putexcel B6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

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
	putexcel H6 = matrix(output), rownames nformat(number_d2)
	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'

}


graph close
clear



