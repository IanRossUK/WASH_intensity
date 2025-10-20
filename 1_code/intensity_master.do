
* Does intensity of household promotion visits modify effectiveness of handwashing with soap and point-of-use water treatment interventions? Systematic re-review and meta-regression


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

cd $github/1_code
do analysis_hwws_intensity_16oct25

cd $github/1_code
do analysis_hwt_intensity_16oct25

cd $github/1_code
do analysis_pooled_intensity_16oct25

*

