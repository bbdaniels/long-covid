// Demographics
use  "${git}/data/long-covid.dta"
histogram age, by(sex,c(1)) start(18) w(1) fc(black) lc(none) barwidth(1) freq
  graph export "${git}/output/descriptives/img/demographics.png" , replace

// Wave timings
use  "${git}/data/long-covid.dta" if covid1a > date("Jan 1 2020" ,"MDY"), clear
histogram covid1a ///
  , fc(black) lc(none) barwidth(25) xlab(,format(%tdMon_CCYY)) ///
    xoverhang xtit(" ") ytit(" ") start(`=date("Jan 1 2020" ,"MDY")') w(30.5) ///
    title("Date of positive covid tests") freq
    
  graph export "${git}/output/descriptives/img/covid-positive.png" , replace

// Test results
use  "${git}/data/long-covid.dta"
graph close _all
* venndiag testpos seropos , t1title("Covid prevalence")
  * something weird with graph overwriting here
  * graph export "${git}/output/descriptives/img/covid-testing.png" , replace
  graph close _all
  
// Health status
use  "${git}/data/long-covid.dta" , clear
tw ///
  (kdensity illness if testpos == 1 , lc(black) lp(dash)) ///
  (kdensity illness if testpos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Tested Positive" 2 "Never Positive")) ///
    xtit("Illness Index (PCA)") ytit(" ")
  
  graph export "${git}/output/descriptives/img/illness-testing.png" , replace

tw ///
  (kdensity illness if seropos == 1 , lc(black) lp(dash)) ///
  (kdensity illness if seropos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Seropositive" 2 "Not Positive")) ///
    xtit("Illness Index (PCA)") ytit(" ")
  
  graph export "${git}/output/descriptives/img/illness-sero.png" , replace
  
// Mental health
use  "${git}/data/long-covid.dta" , clear
tw ///
  (kdensity depression if testpos == 1 , lc(black) lp(dash)) ///
  (kdensity depression if testpos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Tested Positive" 2 "Never Positive")) ///
    xtit("Depression Index (PCA)") ytit(" ")
  
  graph export "${git}/output/descriptives/img/mental-testing.png" , replace

tw ///
  (kdensity depression if seropos == 1 , lc(black) lp(dash)) ///
  (kdensity depression if seropos == 0 , lc(black) lp(solid)) ///
  , legend(on c(1) pos(1) ring(0) order(1 "Seropositive" 2 "Not Positive")) ///
    xtit("Depression Index (PCA)") ytit(" ")
  
  graph export "${git}/output/descriptives/img/mental-sero.png" , replace

// Start disentangling
use  "${git}/data/long-covid.dta" , clear
tw ///
  (lpoly illness age if age < 80) ///
  (lpoly depression age if age < 80) ///
  , by(sex) xtit("Age") ///
    legend(order(1 "Illness Index" 2 "Depression Index"))

  graph export "${git}/output/descriptives/img/health-age.png" , replace

tw ///
  (lpoly seropos age if age < 80) ///
  (lpoly testpos age if age < 80) ///
  , by(sex) xtit("Age") ///
    legend(order(1 "Seropositive" 2 "Tested Positive"))
    
  graph export "${git}/output/descriptives/img/covid-age.png" , replace
  
// Individual health stuff 
use  "${git}/data/long-covid.dta" , clear
local i = 0
foreach var of varlist sym_? {
  local ++i
  local label : var label `var'
  local graphs "`graphs' (lpoly `var' age)"
  local legend `"`legend' `i' "`label'" "'
}
  tw `graphs' , legend(on order(`legend') pos(3) c(1)) xtit("Age") ///
    title("Specific Conditions Prevalence") ylab(0 "0%" .5 "50%" 1 "100%")

  graph export "${git}/output/descriptives/img/conditions-age.png" , replace

// End
