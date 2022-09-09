// Summary Statistics

local com 

local bin seropos testpos covid1c

local con illness sym_? depression ghq?*  any_disease new_disease?

use  "${git}/data/long-covid.dta" , clear


sumstats ///
  (`bin' `con') ///
  (`bin' `con' if sex == 1) ///
  (`bin' `con' if sex == 2) ///
	using "${git}/output/tables/sumstats.xlsx" ///
	, replace stats(mean sd p25 p50 p75 n )
	
	
	foreach var of varlist sym_? new_diseaseA new_diseaseB new_diseaseC  new_diseaseE new_diseaseX {
		logit `var' covid1c age i.sex asset_pca seropos if sex == 2
	}

forest logit (sym_?)(new_disease?) , or b bh t(seropos) c(age i.sex asset_pca ) saving("${git}/output/tables/table-11.xlsx")
forest logit (sym_?)(new_disease?) , or b bh t(testpos) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-12.xlsx")
forest logit (sym_?)(new_disease?) , or b bh t(covid1c) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-13.xlsx")

forest logit (sym_?)(new_disease?) if sex == 1, or b bh t(seropos) c(age i.sex asset_pca ) saving("${git}/output/tables/table-21.xlsx")
forest logit (sym_?)(new_disease?) if sex == 1, or b bh t(testpos) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-22.xlsx")
forest logit (sym_?)(new_disease?) if sex == 1, or b bh t(covid1c) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-23.xlsx")

forest logit (sym_?)(new_disease?) if sex == 2, or b bh t(seropos) c(age i.sex asset_pca ) saving("${git}/output/tables/table-31.xlsx")
forest logit (sym_?)(new_disease?) if sex == 2, or b bh t(testpos) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-32.xlsx")
forest logit (sym_?)(new_diseaseA new_diseaseB new_diseaseC  new_diseaseE ) if sex == 2, or b bh t(covid1c) c(age i.sex asset_pca seropos) saving("${git}/output/tables/table-33.xlsx")

--

// Regressions

use  "${git}/data/long-covid.dta" , clear

cap prog drop mdereg
prog def mdereg

  syntax , var(string asis) [suf(string asis)]
	  
	cap mat drop a
	mat a = r(table)
	local se = a[2,1]
	local df = a[7,1]
	local crit = a[8,1]
	local mde = `se' * (`crit' + -(invt(`df',.2)))
	
	estadd scalar mde = `mde'
	
				local theLabel : var label `var'
			local theCols `"`theCols' "`theLabel'" "`theLabel'""'

			qui sum `var' if e(sample) == 1
			local mean = `r(mean)'
			estadd scalar mean = `mean'
			
			est sto `var'`suf'
	
end

estimates clear
qui foreach var of varlist illness depression any_disease {
  reg `var' testpos age i.sex asset_pca
	  mdereg, var(`var') suf(1)
  reg `var' testpos age i.sex asset_pca seropos
	  mdereg, var(`var') suf(2)
  reg `var' testpos age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var') suf(3)
		
  local list "`list' `var'1 `var'2 `var'3"

}

outwrite `list' using "${git}/output/tables/test.xlsx" , replace stats(N r2 mean mde)

estimates clear
local list ""
qui foreach var of varlist sym_? {

  reg `var' testpos age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var')
		
  local list "`list' `var'"

}

outwrite `list' using "${git}/output/tables/test_sym.xlsx" , replace stats(N r2 mean mde)

estimates clear
local list ""
qui foreach var of varlist sym_? {

  reg `var' testpos#i.sex age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var')
		
  local list "`list' `var'"

}

outwrite `list' using "${git}/output/tables/test_sym-mf.xlsx" , replace stats(N r2 mean mde)

estimates clear
local list ""
qui foreach var of varlist sym_? {

  reg `var' covid1a age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var')
		
  local list "`list' `var'"

}

outwrite `list' using "${git}/output/tables/test_sym-date.xlsx" , replace stats(N r2 mean mde)

estimates clear
local list ""
qui foreach var of varlist sym_? {

  reg `var' testpos#i.sex age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var')
		
  local list "`list' `var'"

}

outwrite `list' using "${git}/output/tables/test_sym-mf.xlsx" , replace stats(N r2 mean mde)

estimates clear
local list ""
qui foreach var of varlist ghq?* {

  reg `var' testpos age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var')
		
  local list "`list' `var'"

}

outwrite `list' using "${git}/output/tables/test_mental.xlsx" , replace stats(N r2 mean mde)

estimates clear
local list ""
qui foreach var of varlist new_disease? {

  reg `var' testpos age i.sex asset_pca seropos, cl(sero_cluster)
	  mdereg, var(`var')
		
  local list "`list' `var'"

}

outwrite `list' using "${git}/output/tables/test_disease.xlsx" , replace stats(N r2 mean mde)

// End
