************ V.1 ******************
****analysis of Forecast Errors****
***********************************
* Mean Amount sent
summ trasferimento
scalar mean_transfer_all = r(mean)
* Mean amount returned
summ return_0
scalar mean_return_0 = r(mean)

summ return_5
scalar mean_return_5 = r(mean)

summ return_10
scalar mean_return_10 = r(mean)

summ return_15
scalar mean_return_15 = r(mean)

summ return_20
scalar mean_return_20 = r(mean)

summ return_25
scalar mean_return_25 = r(mean)

* generate expectations amount return per possibl amount sent
* For receivers behavior
gen  exp_receiver_0 =  exp_receiver_i
replace exp_receiver_0 =  . if trasferimento!=0

gen  exp_receiver_5 =  exp_receiver_i
replace exp_receiver_5 =  . if trasferimento!=5

gen  exp_receiver_10 =  exp_receiver_i
replace exp_receiver_10 =  . if trasferimento!=10

gen  exp_receiver_15 =  exp_receiver_i
replace exp_receiver_15 =  . if trasferimento!=15

gen  exp_receiver_20 =  exp_receiver_i
replace exp_receiver_20 =  . if trasferimento!=20

gen  exp_receiver_25 =  exp_receiver_i
replace exp_receiver_25 =  . if trasferimento!=25

* FE AmountSent
gen forecast_error_transfer_all = exp_sender - mean_transfer_all

* FE amountreturned
gen forecast_error_return_0 =  exp_receiver_0 - mean_return_0
gen forecast_error_return_5 =  exp_receiver_5 - mean_return_5
gen forecast_error_return_10 =  exp_receiver_10 - mean_return_10
gen forecast_error_return_15 =  exp_receiver_15 - mean_return_15
gen forecast_error_return_20 =  exp_receiver_20 - mean_return_20
gen forecast_error_return_25 =  exp_receiver_25 - mean_return_25

gen forecast_error_return_0_all =  exp_receiver_0 - mean_return_0
gen forecast_error_return_5_all =  exp_receiver_5 - mean_return_5
gen forecast_error_return_10_all =  exp_receiver_10 - mean_return_10
gen forecast_error_return_15_all =  exp_receiver_15 - mean_return_15
gen forecast_error_return_20_all =  exp_receiver_20 - mean_return_20
gen forecast_error_return_25_all =  exp_receiver_25 - mean_return_25

* Creation of single normalised var for expected return rate
gen forecast_error_return_0_norm = forecast_error_return_0_all/25
gen forecast_error_return_5_norm = forecast_error_return_5_all/35
gen forecast_error_return_10_norm = forecast_error_return_10_all/45
gen forecast_error_return_15_norm = forecast_error_return_15_all/55
gen forecast_error_return_20_norm = forecast_error_return_20_all/65
gen forecast_error_return_25_norm = forecast_error_return_25_all/75

gen forecast_error_return_norm=forecast_error_return_0_norm
replace forecast_error_return_norm=forecast_error_return_5_norm if trasferimento==5
replace forecast_error_return_norm=forecast_error_return_10_norm if trasferimento==10
replace forecast_error_return_norm=forecast_error_return_15_norm if trasferimento==15
replace forecast_error_return_norm=forecast_error_return_20_norm if trasferimento==20
replace forecast_error_return_norm=forecast_error_return_25_norm if trasferimento==25

gen forecast_error_return_norm_south = forecast_error_return_norm if sud == 1
gen forecast_error_return_norm_north = forecast_error_return_norm if sud == 0

/* OLD CODE ON FE

******************************
* Forecast errors
* Mean transfer
gen mean_transfer_NM = 10.4955
gen mean_transfer_M_OUT = 14.4481
gen mean_transfer_M_ING = 15.2294

* Mean return 0
gen mean_return_0_NM = 3.25676
gen mean_return_0_M_OUT = 3.77273
gen mean_return_0_M_ING = 4.58257

* Mean return 5
gen mean_return_5_NM = 6.83333
gen mean_return_5_M_OUT = 8.81493
gen mean_return_5_M_ING = 10.4352

* Mean return 10
gen mean_return_10_NM = 11.4189
gen mean_return_10_M_OUT = 14.2662
gen mean_return_10_M_ING = 15.9398

* Mean return 15
gen mean_return_15_NM = 15.2117 
gen mean_return_15_M_OUT = 19.8182
gen mean_return_15_M_ING = 21.0556

* Mean return 20
gen mean_return_20_NM = 19.1441 
gen mean_return_20_M_OUT = 25.9123
gen mean_return_20_M_ING = 26.1481

* Mean return 25
gen mean_return_25_NM = 23.0135
gen mean_return_25_M_OUT = 29.8377
gen mean_return_25_M_ING = 31.6065

* gen weighted means
gen mean_transfer_OUT = mean_transfer_NM*.8879+mean_transfer_M_OUT*0.1121
gen mean_return_0_OUT = mean_return_0_NM*.8879+mean_return_0_M_OUT*0.1121
gen mean_return_5_OUT = mean_return_5_NM*.8879+mean_return_5_M_OUT*0.1121
gen mean_return_10_OUT = mean_return_10_NM*.8879+mean_return_10_M_OUT*0.1121
gen mean_return_15_OUT = mean_return_15_NM*.8879+mean_return_15_M_OUT*0.1121
gen mean_return_20_OUT = mean_return_20_NM*.8879+mean_return_20_M_OUT*0.1121
gen mean_return_25_OUT = mean_return_25_NM*.8879+mean_return_25_M_OUT*0.1121

*sum mean_transfer_OUT mean_return_0_OUT  mean_return_5_OUT mean_return_10_OUT mean_return_15_OUT mean_return_20_OUT mean_return_25_OUT

* For receivers behavior
gen  exp_receiver_0 =  exp_receiver_i
replace exp_receiver_0 =  . if trasferimento!=0

gen  exp_receiver_5 =  exp_receiver_i
replace exp_receiver_5 =  . if trasferimento!=5

gen  exp_receiver_10 =  exp_receiver_i
replace exp_receiver_10 =  . if trasferimento!=10

gen  exp_receiver_15 =  exp_receiver_i
replace exp_receiver_15 =  . if trasferimento!=15

gen  exp_receiver_20 =  exp_receiver_i
replace exp_receiver_20 =  . if trasferimento!=20

gen  exp_receiver_25 =  exp_receiver_i
replace exp_receiver_25 =  . if trasferimento!=25


gen forecast_error_transfer =  exp_sender - mean_transfer_OUT
replace forecast_error_transfer = exp_sender - mean_transfer_M_ING if ingroup==1

gen forecast_error_return_0 =  exp_receiver_0 - mean_return_0_OUT
replace forecast_error_return_0 = exp_receiver_0 - mean_return_0_M_ING if ingroup==1

gen forecast_error_return_5 =  exp_receiver_5 - mean_return_5_OUT
replace forecast_error_return_5 = exp_receiver_5 - mean_return_5_M_ING if ingroup==1

gen forecast_error_return_10 =  exp_receiver_10 - mean_return_10_OUT
replace forecast_error_return_10 = exp_receiver_10 - mean_return_10_M_ING if ingroup==1

gen forecast_error_return_15 =  exp_receiver_15 - mean_return_15_OUT
replace forecast_error_return_15 = exp_receiver_15 - mean_return_15_M_ING if ingroup==1

gen forecast_error_return_20 =  exp_receiver_20 - mean_return_20_OUT
replace forecast_error_return_20 = exp_receiver_20 - mean_return_20_M_ING if ingroup==1

gen forecast_error_return_25 =  exp_receiver_25 - mean_return_25_OUT
replace forecast_error_return_25 = exp_receiver_25 - mean_return_25_M_ING if ingroup==1

* absolute errors
gen forecast_error_transfer_abs=abs(forecast_error_transfer)
gen forecast_error_return_0_abs=abs(forecast_error_return_0)
gen forecast_error_return_5_abs=abs(forecast_error_return_5)
gen forecast_error_return_10_abs=abs(forecast_error_return_10)
gen forecast_error_return_15_abs=abs( forecast_error_return_15)
gen forecast_error_return_20_abs=abs( forecast_error_return_20)
gen forecast_error_return_25_abs=abs( forecast_error_return_25)

* Creation of single normalised var for expected return rate

gen forecast_error_return_0_norm = forecast_error_return_0/25
gen forecast_error_return_5_norm = forecast_error_return_5/35
gen forecast_error_return_10_norm = forecast_error_return_10/45
gen forecast_error_return_15_norm = forecast_error_return_15/55
gen forecast_error_return_20_norm = forecast_error_return_20/65
gen forecast_error_return_25_norm = forecast_error_return_25/75

gen forecast_error_return_norm=forecast_error_return_0_norm
replace forecast_error_return_norm=forecast_error_return_5_norm if trasferimento==5
replace forecast_error_return_norm=forecast_error_return_10_norm if trasferimento==10
replace forecast_error_return_norm=forecast_error_return_15_norm if trasferimento==15
replace forecast_error_return_norm=forecast_error_return_20_norm if trasferimento==20
replace forecast_error_return_norm=forecast_error_return_25_norm if trasferimento==25

gen forecast_error_return_norm_abs=abs(forecast_error_return_norm)
*/

