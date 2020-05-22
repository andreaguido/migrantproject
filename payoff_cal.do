* global FOR NORTHERNS
scalar N_r_0 = 3.83
global N_r_5 = 8.85
global N_r_10 = 14.45
global N_r_15 = 19.72
global N_r_20 = 24.83
global N_r_25 = 29.62

* global FOR SOUTHERNERS
global S_r_0 = 2.89
global S_r_5 = 6.89
global S_r_10 = 10.78
global S_r_15 = 13.90
global S_r_20 = 19.32
global S_r_25 = 21.42

gen profit_same = 0 
replace profit_same = (25-trasferimento + `=N_r_0') if sud == 0 & trasferimento == 0
replace profit_same = 25-trasferimento + `=N_r_5' if sud == 0 & trasferimento == 5
replace profit_same = 25-trasferimento + `=N_r_10' if sud == 0 & trasferimento == 10
replace profit_same = 25-trasferimento + `=N_r_15' if sud == 0 & trasferimento == 15
replace profit_same = 25-trasferimento + `=N_r_20' if sud == 0 & trasferimento == 20
replace profit_same = 25-trasferimento + `=N_r_25' if sud == 0 & trasferimento == 25

replace profit_same = (25-trasferimento + `=S_r_0') if sud == 1 & trasferimento == 0
replace profit_same = 25-trasferimento + `=S_r_5' if sud == 1 & trasferimento == 5
replace profit_same = 25-trasferimento + `=S_r_10' if sud == 1 & trasferimento == 10
replace profit_same = 25-trasferimento + `=S_r_15' if sud == 1 & trasferimento == 15
replace profit_same = 25-trasferimento + `=S_r_20' if sud == 1 & trasferimento == 20
replace profit_same = 25-trasferimento + `=S_r_25' if sud == 1 & trasferimento == 25


ttest profit_same , by(sud)

replace profit_same = (25-trasferimento + `=N_r_0') if sud == 1 & trasferimento == 0
replace profit_same = 25-trasferimento + `=N_r_5' if sud == 1 & trasferimento == 5
replace profit_same = 25-trasferimento + `=N_r_10' if sud == 1 & trasferimento == 10
replace profit_same = 25-trasferimento + `=N_r_15' if sud == 1 & trasferimento == 15
replace profit_same = 25-trasferimento + `=N_r_20' if sud == 1 & trasferimento == 20
replace profit_same = 25-trasferimento + `=N_r_25' if sud == 1 & trasferimento == 25

ttest profit_same , by(sud)
ranksum profit_same, by(sud)
