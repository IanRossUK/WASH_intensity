
* Does intensity of household promotion visits modify effectiveness of handwashing with soap and point-of-use water treatment interventions? Systematic re-review and meta-regression
* Intervention: pooled

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
*/		exclude those without HH visits 
**************************************************************************

clear
cd $github/2_input
use pooled_intensity
codebook freq_prim
drop if total_hh_visits == 0 | total_hh_visits == 1
keep if int_type == "chlorination" | int_type == "hwws"
cd $github/3_output/sensitivity_pooled

**************************************************************************
*/		pooled on DD
**************************************************************************


*DD freq
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study_pool)
	meta forestplot, subgroup(freq_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_hwt_metan_prim.png, replace
	meta summ, subgroup(freq_prim)  eform(Risk ratios)
	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel set metareg_pooled.xlsx, sheet(example1) replace
	putexcel B10 = matrix(ES), rownames nformat(number_d2)
		
	meta regress i.freq_prim i.int_cat, random(dlaird)
	putexcel B1 = "pool DD freq"
	putexcel B2 = `e(I2_res)'
	putexcel B3 = `e(p)'

	matrix b = e(b)
	putexcel B6 = matrix(b), rownames nformat(number_d2)
	
	matrix output = r(table)
	putexcel B15 = matrix(output), rownames nformat(number_d2)

	
	meta summ, eform(Risk ratios)
	putexcel B4 = `r(I2)'

	
	
*DD visnum
	meta set dd_ln_es dd_ln_se, random(dlaird) studylabel(study_pool)
	meta forestplot, subgroup(visnum_prim) nullrefline esrefline eform(Risk ratios)
	graph export dd_hwt_metan_visnum.png, replace
	meta summ, subgroup(visnum_prim)  eform(Risk ratios)
	matrix list r(esgroup) /// need to exponentiate
	
	matrix ES = r(esgroup)
	putexcel H10 = matrix(ES), rownames nformat(number_d2)
	
	meta regress i.visnum_prim i.int_cat, random(dlaird)
		
	putexcel D1 = "pool DD visnum"
	putexcel D2 = `e(I2_res)'
	putexcel D3 = `e(p)'

	matrix b = e(b)
	putexcel B7 = matrix(b), rownames nformat(number_d2)

	matrix output = r(table)
	putexcel J15 = matrix(output), rownames nformat(number_d2)

	
	meta summ, eform(Risk ratios)
	putexcel D4 = `r(I2)'
                                                              
clear
graph close




