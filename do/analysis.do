// Table 1. Summary Statistics
use  "${git}/data/long-covid.dta" , clear

gen rural = (sero_type == 1) & !missing(sero_type)
  lab var rural "Rural Residence"
gen edu_prim = education > 1 & !missing(education)
  lab var edu_prim "Primary Education"
gen edu_seco = education > 4 & !missing(education)
  lab var edu_seco "Secondary Education"

lab var covid9 "Vaccine 1"
lab var covid10 "Vaccine 2"
lab var covid11 "Vaccine B"
lab var covid1c "Hospitalized"

local list age rural edu_prim edu_seco asset_pca covid9 covid10 covid11 testpos covid1c

sumstats ///
  (seropos ) ///
  (seropos if sex == 1 ) ///
  (seropos if sex == 2 ) ///
  (`list' if age != .) ///
  (`list' if sex == 1 & age != .) ///
  (`list' if sex == 2 & age != .) ///
  using "${git}/output/tables/tab-1.xlsx" ///
  , replace stats(mean sd p25 p50 p75 n )

// Table 2. Summary Statistics
use  "${git}/data/long-covid.dta" if age != ., clear

foreach var of varlist ghq?* {
  replace `var' = (`var' > 2) if !missing(`var')
}

local con illness sym_? depression ghq?* any_disease new_disease?

sumstats ///
  (`bin' `con') ///
  (`bin' `con' if sex == 1) ///
  (`bin' `con' if sex == 2) ///
	using "${git}/output/tables/tab-2.xlsx" ///
	, replace stats(mean sd)

// Figure. Comparisons



//
