
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

// End
