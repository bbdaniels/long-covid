// Demographics
histogram age, by(sex,c(1)) start(18) w(1) fc(black) lc(none) barwidth(1) freq
  graph export "${git}/output/img/demographics.png" , replace

// Wave timings
use  "${git}/data/long-covid.dta" if covid1a > date("Jan 1 2020" ,"MDY"), clear
histogram covid1a ///
  , fc(black) lc(none) barwidth(25) xlab(,format(%tdMon_CCYY)) ///
    xoverhang xtit(" ") ytit(" ") start(`=date("Jan 1 2020" ,"MDY")') w(30.5) ///
    title("Date of positive covid tests") freq
    
  graph export "${git}/output/img/covid-positive.png" , replace

// Test results
use  "${git}/data/long-covid.dta"
venndiag testpos seropos , t1title("Covid prevalence")

  graph export "${git}/output/img/covid-testing.png" , replace
  
// Health status
use  "${git}/data/long-covid.dta" , clear
tw ///
  (kdensity illness if testpos == 1 , lc(black) lp(dash)) ///
  (kdensity illness if testpos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Tested Positive" 2 "Never Positive")) ///
    xtit("Illness Index (PCA)") ytit(" ")
  
  graph export "${git}/output/img/illness-testing.png" , replace

tw ///
  (kdensity illness if seropos == 1 , lc(black) lp(dash)) ///
  (kdensity illness if seropos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Seropositive" 2 "Not Positive")) ///
    xtit("Illness Index (PCA)") ytit(" ")
  
  graph export "${git}/output/img/illness-sero.png" , replace
  
// Mental health
use  "${git}/data/long-covid.dta" , clear
tw ///
  (kdensity depression if testpos == 1 , lc(black) lp(dash)) ///
  (kdensity depression if testpos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Tested Positive" 2 "Never Positive")) ///
    xtit("Depression Index (PCA)") ytit(" ")
  
  graph export "${git}/output/img/mental-testing.png" , replace

tw ///
  (kdensity depression if seropos == 1 , lc(black) lp(dash)) ///
  (kdensity depression if seropos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Seropositive" 2 "Not Positive")) ///
    xtit("Depression Index (PCA)") ytit(" ")
  
  graph export "${git}/output/img/mental-sero.png" , replace
  
// End
