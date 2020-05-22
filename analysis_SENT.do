******************************
***ANALYSIS OF AMOUNTS SENT***
******************************
* DEFINE DIRECTORIES
global data_root "Data"
global output_root "Output"

cd "$data_root"
use data_sender, clear

* use file clean_data_SENT.do to clean up the data
cd ..
run "clean_data_SENT.do"
* use the file FE.do to compute forecast errors (see paper)
run "compute_FE.do"


**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

global controls "ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"
label var ingroup "Ingroup" 
label var membroatt "Member"
label var membrosolopass "Dropout"
label var femmina "Gender"
label var eta_g "Age"
label var eta_g_2 "Age_squared"
label var sodred_dum "Income_dissat"
label var abitanti_gr "Town_size"
label var laurea "Bachelor’s_degree"
label var superiore "Upper_secondary"
label var pensionato "Retired"
label var nucleo "Family_unit"
label var nubile "Single"
label var figlio_unico "Only_Child"
label var credente "Believer"
label var pratic_culto "Practicing_Catholic"
label var divorziato "Divorced"
label var soddsalute "Health_sat"
label var risfin "Risfin"
label var errori "Mistakes"
label var soddsalute "Health_sat"
label var experimenter "Experimenter"
label var sud "South"
label var centro "Centre"
label var trasferimento "Amount Sent"
label var ave_return_norm "Average Return Rate"
label var exp_sender "Amount Sent Exp."
label var exp_receiver_norm "Return Rate Exp."

******************ANALYSIS OF EXPECTATIONS on AMOUNT SENT****************************
eststo clear
* Basic impact of south
eststo: ologit exp_sender sud $controls, robust
eststo: ologit exp_sender sud sud_X_ingroup $controls, robust
eststo: ologit exp_sender sud trasferimento $controls, robust
eststo: ologit exp_sender sud trasferimento sud_X_ingroup $controls, robust
cd ..
cd "$output_root"
esttab using "table_beliefs_on_sender.rtf", b(3) se(3) label replace

*****************Sign tests on forecast errors**********************
***on amount sent -- check whether more pessimists in South sample
gen pessimists_sender_south = 1 if forecast_error_transfer_all <0 & sud == 1
replace pessimists_sender_south = 0 if pessimists_sender_south ==. & sud == 1
gen pessimists_sender_north = 1 if forecast_error_transfer_all <0 & sud == 0
replace pessimists_sender_north = 0 if pessimists_sender_north ==. & sud == 0
summ pessimists_sender_south
summ pessimists_sender_north
* TEST PROPORTIONS: RESULTS: HIGHER % IN SOUTH THAN IN NORTH (69% VS 47%)
prtest pessimists_sender_south = 0.5
prtest pessimists_sender_north = 0.5
prtest pessimists_sender_south = pessimists_sender_north
* TEST ON FORECAST ERROR MAGNITUDE
ranksum abs_forecast_error_transfer_all, by(sud)

*****************CHECK OF EXPERIMENTER EFFECT***********************
gen South_X_Experimenter = sud*experimenter
eststo: ologit exp_sender sud trasferimento sud_X_ingroup South_X_Experimenter $controls, robust

*****************CHECK OF MEMBER EFFECT by SOUTH***********************
gen South_X_Member = sud*membroatt
eststo: ologit exp_sender sud trasferimento sud_X_ingroup South_X_Member $controls, robust

******************AMOUNT SENT****************************
eststo clear
* Basic impact of south
global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"
eststo: ologit trasferimento sud $controls, robust

* Impact of beliefs: south effect disappears!
eststo: ologit trasferimento sud exp_sender $controls, robust
eststo: ologit trasferimento sud exp_receiver_norm $controls, robust
eststo: ologit trasferimento sud ave_return_norm $controls, robust
eststo: ologit trasferimento sud exp_sender exp_receiver_norm ave_return_norm $controls, robust

esttab using "table_amount_sent.rtf", label b(3) se(3) replace

* profit analysis 
preserve
collapse (mean) return_0 (mean) return_5 (mean) return_10 (mean) return_15 (mean) return_20 (mean) return_25, by(sud)
gen profit_0 = 25 + return_0
gen profit_5 = 25 -5 + return_5
gen profit_10 = 25 -10 + return_10
gen profit_15 = 25 -15 + return_15
gen profit_20 = 25 -20 + return_20
gen profit_25 = 25 -25 + return_25
restore

preserve
collapse (mean) trasferimento, by(sud)
* INSERT HERE CODE FOR OUTPUT ################
restore

**SOBEL-GOODMAN MEDIATION ANALYSIS
*One variable at a time:
*Exp on Senders
* Reminder::: 	south -> amount transferred : c path or total effect
*				south -> beliefs : a path or coeff a
*				beliefs -> amount transferred : b path or coeff b
*				indirect effect : a*b
*				south -> amount transf given beliefs : c' path or direct effect
global controls_mediation "ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute errori experimenter"
sgmediation trasferimento, iv(sud) mv(exp_sender) cv($controls_mediation) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(exp_sender) cv($controls_mediation) 
*Exp on Receiver
sgmediation trasferimento, iv(sud) mv(exp_receiver_norm) cv($controls_mediation) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(exp_receiver_norm) cv($controls_mediation) 
*Avg returned amount
sgmediation trasferimento, iv(sud) mv(ave_return_norm) cv($controls_mediation) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(ave_return_norm) cv($controls_mediation)
*Financial Risk
sgmediation trasferimento, iv(sud) mv(risfin) cv($controls_mediation) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(risfin) cv($controls_mediation)  

*All variables:
*Exp on Senders
sgmediation trasferimento, iv(sud) mv(exp_sender) cv(exp_receiver_norm ave_return_norm $controls) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(exp_sender) cv(exp_receiver_norm ave_return_norm $controls) 
*Exp on Receiver
sgmediation trasferimento, iv(sud) mv(exp_receiver_norm) cv(exp_sender ave_return_norm $controls) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(exp_receiver_norm) cv(exp_sender ave_return_norm $controls) 
*Avg returned amount
sgmediation trasferimento, iv(sud) mv(ave_return_norm) cv(exp_receiver_norm exp_sender $controls) 
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation trasferimento, iv(sud) mv(ave_return_norm) cv(exp_receiver_norm exp_sender $controls)

***ROBUSTNESS CHECKS***
* DEMOGRAPHICS TESTS
* test whether association members from the south differ from non-members
preserve
drop if sud != 1 | years_in_PR == .
bys membroatt : summ eta
ranksum eta , by(membroatt)
ranksum femmina, by(membroatt) // LESS WOMEN IN ASSOCIATIONS
ranksum(abitanti_gr), by(membroatt)
ranksum(laurea), by(membroatt)
ranksum(pensionato), by(membroatt)
ranksum(nubile), by(membroatt)
ranksum(sodred_dum), by(membroatt)
ranksum years_in_PR_norm, by(membroatt) // LESS YRS SPENT IN REGION IF MEMBER
ranksum(trasferimento), by(membroatt)
ranksum(ave_return_norm), by(membroatt)
restore

* FALSE CONSENSUS
gen falsecon = 1 if trasferimento == exp_sender
replace falsecon = 0 if falsecon == .
eststo clear
 ologit trasferimento sud $controls, robust
 ologit trasferimento sud falsecon $controls, robust
 ologit trasferimento sud exp_sender falsecon $controls, robust
 ologit trasferimento sud exp_receiver_norm falsecon $controls, robust
 ologit trasferimento sud ave_return_norm falsecon $controls, robust
eststo: ologit trasferimento sud exp_sender exp_receiver_norm ave_return_norm falsecon $controls, robust
cd "..\$output_root"
esttab using "false_consensus_sent.rtf", label r2 ar2 replace
