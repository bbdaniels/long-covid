// Set up data sets for long COVID study

use "${box}/FF-LCS_Field_Sero_data merged_unidentified.dta" , clear

// Make wellness indicators
  
  ren tiredeness tiredness
  local i = 0
  foreach var of varlist fever smell tiredness digestion ENT heart cough urination {
    local ++i
    gen sym_`i' = `var'
    local label = proper("`var'")
    lab var sym_`i' "`label'"
  }
    lab var sym_5 "ENT"
  
  pca sym_?
    predict illness 
    lab var illness "Illness Index (PCA)"

// Make covid indicators

  gen testpos = (covid_test==1) if !missing(covid_test)
    lab var testpos "Tested Positive"

  gen seropos = (sero_result == 2)
    lab var seropos "Seropositive"
    
    
    
// Mental health

  pca ghq1 ghq2 ghq3 ghq4 ghq5 ghq6 ghq7 ghq8 ghq9 ghq10 ghq11 ghq12
    predict depression
    lab var depression "Depression Index (PCA)"

// Keep only 

save "${git}/data/long-covid.dta" , replace



// End
