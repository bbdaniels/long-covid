// Set up data sets for long COVID study

use "${box}/FF-LCS_Field_Sero_data merged_unidentified.dta" , clear

// Make wellness indicators


// Make covid indicators

  gen testpos = (covid_test==1) if !missing(covid_test)
    lab var testpos "Tested Positive"

  gen seropos = (sero_result == 2)
    lab var seropos "Seropositive"
    
    
    
// Mental health

  pca ghq1 ghq2 ghq3 ghq4 ghq5 ghq6 ghq7 ghq8 ghq9 ghq10 ghq11 ghq12
    predict depression
    lab var depression "Depression Index (P)"

// Keep only 

save "${git}/data/long-covid.dta" , replace



// End
