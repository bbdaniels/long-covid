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

use  "${git}/data/long-covid.dta" if age!=., clear
lab var covid1c "Hospitalized"
tempfile a b c

forest reg (illness depression any_disease)(sym_?) ///
  , b bh mde t(seropos) c(age i.sex) ///
    graphopts(scale(0.7) nodraw saving(`a') note("") ///
      xlab(0.25 "+0.25" -0.25 "-0.25" 0 "Zero" .5 "+0.50" -.5 "-0.50"))
forest reg (illness depression any_disease)(sym_?) ///
  , b bh mde t(testpos) c(age i.sex) ///
    graphopts(scale(0.7)  nodraw saving(`b')  note("") ///
      xlab(0.25 "+0.25" -0.25 "-0.25" 0 "Zero" .5 "+0.50" -.5 "-0.50"))
forest reg (illness depression any_disease)(sym_?) ///
  , b bh mde t(covid1c) c(age i.sex) ///
    graphopts(scale(0.7)  nodraw saving(`c')  note("") ///
      xlab(0.25 "+0.25" -0.25 "-0.25" 0 "Zero" .5 "+0.50" -.5 "-0.50"))

    graph combine "`a'" "`b'" "`c'" , c(1)
    graph draw , ysize(5)

  graph export "${git}/output/fig-compare.png" , replace

// Tables. ORs.
use  "${git}/data/long-covid.dta" if age!=., clear
lab var covid1c "Hospitalized"

forest logit (sym_?)(new_disease?) , or b bh t(seropos) c(age i.sex asset_pca ) saving("${git}/output/tables/table-11.xlsx")
forest logit (sym_?)(new_disease?) , or b bh t(testpos) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-12.xlsx")
forest logit (sym_?)(new_disease?) , or b bh t(covid1c) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-13.xlsx")

forest logit (sym_?)(new_disease?) if sex == 1, or b bh t(seropos) c(age i.sex asset_pca ) saving("${git}/output/tables/table-21.xlsx")
forest logit (sym_?)(new_disease?) if sex == 1, or b bh t(testpos) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-22.xlsx")
forest logit (sym_?)(new_disease?) if sex == 1, or b bh t(covid1c) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-23.xlsx")

forest logit (sym_?)(new_disease?) if sex == 2, or b bh t(seropos) c(age i.sex asset_pca ) saving("${git}/output/tables/table-31.xlsx")
forest logit (sym_?)(new_disease?) if sex == 2, or b bh t(testpos) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-32.xlsx")
forest logit (sym_?)(new_diseaseA new_diseaseB new_diseaseC  new_diseaseE ) if sex == 2, or b bh t(covid1c) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-33.xlsx")


//
