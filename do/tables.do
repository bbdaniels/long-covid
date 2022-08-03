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
