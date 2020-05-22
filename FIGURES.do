*** FIGURES ***

* v.1
* figure 1
* Forecast errors over amount sent broken down SOUTH variable PANEL a
label define south 0 "Non-Southerners" 1 "Southerners"
label values sud south
label variable forecast_error_transfer_all "Forecast Error over Amount Sent"
label variable forecast_error_transfer "Forecast Error over Amount Sent"
graph box forecast_error_transfer, over(sud) medtype(marker) medmarker(msymbol(square))
graph box forecast_error_transfer_all, over(sud) medtype(marker) medmarker(msymbol(square))
ranksum forecast_error_transfer, by(sud)
gr export "../Output/FE.png", replace
* Forecast errors over amount returned broken down by SOUTH variable PANEL b
label variable forecast_error_return_norm_north "Forecast Error over Amount Sent"
label variable forecast_error_return_norm_south "Forecast Error over Amount Sent"
graph box forecast_error_return_norm_north forecast_error_return_norm_south, over(trasferimento) medtype(marker) medmarker(msymbol(square)) ///
legend(order(1 "Non-Southerners" 2 "Southerners")) bar(1, fcolor(gray)) bar(2, fcolor(black)) ytitle(FE on Amount Retuned)

* figure 2 -- histograms for amount sent by region of origin 
tostring trasferimento, gen(f_trasferimento)

gen bar_trasf_south = trasferimento if sud == 1
gen bar_trasf_north = trasferimento if sud == 0
label variable bar_trasf_south "South"
label variable bar_trasf_north "North"
graph bar (percent) bar_trasf_south bar_trasf_north, over(trasferimento) title("Amount Sent") bar(1, fcolor(gray)) bar(2, fcolor(black)) /// 
legend(order(1 "Southerners" 2 "Non-Southerners")) ytitle(% of Obs.)
gr export "../Output/Amount_Sent.png", replace
* figure 3 -- bar plot of amount returned by region of origin
preserve
reshape long return_ , i(idlungo) j(AmountSent)
collapse (mean) return_ , by(AmountSent sud)
gen return_south = return_ if sud == 1
gen return_north = return_ if sud == 0
graph bar return_south return_north , over(AmountSent ) legend(order(1 "Southerners" 2 "Non-Southerners")) title("Amount Returned") ylabel(0(5)30) ///
bar(1, fcolor(gray)) bar(2, fcolor(black)) ytitle(Mean Amount Returned)
gr export "../Output/Amount_Returned.png", replace
restore
