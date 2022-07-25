
// Wave timings
use  "${git}/data/long-covid.dta" if covid1a > date("Jan 1 2020" ,"MDY"), clear
histogram covid1a ///
  , fc(black) lc(none) barwidth(25) xlab(,format(%tdMon_CCYY)) ///
    xoverhang xtit(" ") start(`=date("Jan 1 2020" ,"MDY")') w(30.5) ///
    title("Date of positive covid tests")
    
  graph export "${git}/output/covid-positive.png" , replace
