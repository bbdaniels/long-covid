
// Descriptive bits
betterbar sym_? ///
  , over(testpos) xlab(0 "0%" .5 "50%") barlab n ci pct ///
    legend(on order(1 "No Positive Test" 2 "Positive Test")) 
  graph export "${git}/output/causal/img/test-symptoms.png" , replace

betterbar sym_? ///
  , over(seropos) xlab(0 "0%" .5 "50%") barlab n ci pct ///
    legend(on order(1 "Not Seropositive" 2 "Seropositive")) 
      graph export "${git}/output/causal/img/sero-symptoms.png" , replace

// Descriptive bits
betterbar ghq?* ///
  , over(testpos) xlab(1 2 3 4) barlab n ci ///
    legend(on order(1 "No Positive Test" 2 "Positive Test")) 
  graph export "${git}/output/causal/img/test-depression.png" , replace

betterbar ghq?* ///
  , over(seropos) xlab(1 2 3 4) barlab n ci ///
    legend(on order(1 "Not Seropositive" 2 "Seropositive")) 
      graph export "${git}/output/causal/img/sero-depression.png" , replace

    
// Descriptive bits
betterbar new_disease? ///
  , over(testpos) xlab(0 "0%" .5 "50%") barlab n ci pct ///
    legend(on order(1 "No Positive Test" 2 "Positive Test")) 
  graph export "${git}/output/causal/img/test-disease.png" , replace

betterbar new_disease? ///
  , over(seropos) xlab(0 "0%" .5 "50%") barlab n ci pct ///
    legend(on order(1 "Not Seropositive" 2 "Seropositive")) 
      graph export "${git}/output/causal/img/sero-disease.png" , replace

// "Causal" estimates of long covid

use  "${git}/data/long-covid.dta" , clear
forest reg (illness depression)(sym_?) , b bh t(testpos) c(age i.sex asset_pca)
  graph export "${git}/output/causal/img/topline-control.png" , replace
forest reg (illness depression)(sym_?) , b bh t(testpos) c(age i.sex asset_pca seropos)
  graph export "${git}/output/causal/img/topline-control-sero.png" , replace
forest reg (illness depression)(sym_?) , b bh t(testpos) c(age i.sex asset_pca seropos) mde
  graph export "${git}/output/causal/img/topline-control-sero-mde.png" , replace
  
forest reg (illness depression)(sym_?) , b bh t(seropos) c(age i.sex asset_pca) mde
  graph export "${git}/output/causal/img/sero-control-mde.png" , replace
forest reg (illness depression)(sym_?) , b bh t(covid1c) c(age i.sex asset_pca seropos) mde
  graph export "${git}/output/causal/img/hosp-control-mde.png" , replace

forest reg (ghq?*) , b bh t(testpos) c(age i.sex asset_pca)
  graph export "${git}/output/causal/img/depression-control.png" , replace
forest reg (ghq?*) , b bh t(testpos) c(age i.sex asset_pca seropos)
  graph export "${git}/output/causal/img/depression-control-sero.png" , replace
forest reg (ghq?*) , b bh t(testpos) c(age i.sex asset_pca seropos) mde
  graph export "${git}/output/causal/img/depression-control-sero-mde.png" , replace

// Generate power tests



lab var illness "Wellness"
lab var depression "Depression"
forest_power reg (illness depression)  ,  b t(testpos) at(1(1)20) c(age i.sex asset_pca seropos)
    graph export "${git}/output/causal/img/power-topline.png" , replace

forest_power reg (sym_?)  ,  b t(testpos) at(1(1)20) c(age i.sex i.asset_pca seropos) 
    graph export "${git}/output/causal/img/power-symptoms.png" , replace

forest_power reg (ghq?*)  ,  b t(testpos) at(1(1)20) c(age i.sex asset_pca seropos)
    graph export "${git}/output/causal/img/power-depression.png" , replace

forest_power reg (new_disease?)  ,  b t(testpos) at(1(1)20) c(age i.sex asset_pca seropos)
    graph export "${git}/output/causal/img/power-conditions.png" , replace

forest_power reg (sym_?)  ,  b t(covid1c) at(1(1)20) c(age i.sex asset_pca seropos)
    graph export "${git}/output/causal/img/power-symptoms-hospitalized.png" , replace


// Attrition

use  "${git}/data/long-covid.dta" , clear

gen rand = runiform()
forv i = 1/100 {
    gen cough_`i' = (rand > (`i'/100))
    replace cough_`i' = cough if cough != .
      lab var cough_`i' " "
}

forest reg (cough_1-cough_100) , t(seropos)  mde c(i.sero_dist i.sero_type) 
    graph export "${git}/output/causal/img/seropos_attrition.png" , replace

use  "${git}/data/long-covid.dta" , clear

gen rand = runiform()
forv i = 1/100 {
    gen cough_`i' = (rand > (`i'/100))
    replace cough_`i' = cough if cough != .
      lab var cough_`i' "`=100-`i''% Cough"
}

forest_power reg (cough_1 cough_?0*) , t(seropos) at(1(1)20) c(i.sero_dist i.sero_type) 
    graph export "${git}/output/causal/img/seropos_attrition2.png" , replace

// End
