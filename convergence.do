**ANALYSIS OF CONVERGENCE**
***************************

** SETTINGS
global data_root "Data"
global output_root "Output"
*********************************************************************************************

**SENDER DECISION**
*******************
cd "$data_root"
use data_sender, clear

cd ..
run "clean_data_SENT.do"

*UNEXPLAINED values:
drop if exp_sender == 12.5 | exp_sender == 23

*create dummy sud and treatment
quietly: gen sud_X_ingroup = sud*ingroup

global controls "centro sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

eststo clear
*********************************************************************************************
**run the regression
quietly: eststo sent_1: ologit trasferimento sud  years_in_PR_norm exp_sender exp_receiver_norm ave_return_norm $controls, robust
quietly: eststo sent_2: ologit trasferimento sud  years_in_PR_norm years_in_PR_norm_X_sud exp_sender exp_receiver_norm ave_return_norm $controls, robust
*********************************************************************************************
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud

**SENDER BELIEFS**
******************
**run the regression
quietly: eststo belief_sent_1: ologit exp_sender sud years_in_PR_norm trasferimento $controls, robust
quietly: eststo belief_sent_2: ologit exp_sender sud years_in_PR_norm years_in_PR_norm_X_sud trasferimento $controls, robust
*********************************************************************************************
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud

**RECEIVER BELIEFS**
********************
cd "$data_root"
use data_sender, clear

cd ..
run "clean_data_SENT.do"
**create dummy sud and treatment
quietly: gen sud_X_ingroup = sud*ingroup

global controls "centro sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

quietly: eststo belief_return_1: tobit exp_receiver_norm sud years_in_PR_norm ave_return_norm $controls, ll(0) ul(1) robust
quietly: eststo belief_return_2: tobit exp_receiver_norm sud years_in_PR_norm years_in_PR_norm_X_sud ave_return_norm $controls, ll(0) ul(1) robust
*********************************************************************************************
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud

**RECEIVER DECISIONS**
**********************
cd "$data_root"
use data_receiver, clear

cd ..
run "clean_data_RET.do"
xtset  idlungo  dec_num

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
label var years_in_PR_norm "Years in Parma"
label var years_in_PR_norm_X_sud "Years in Parma_X_South"
label var sud "South"

label var centro "Centre"
label var trasferimento "Amount Sent"
label var exp_sender "Amount Sent Exp."
label var exp_receiver_norm "Amount returned Exp."
label var ave_return_norm "Average Return Rate"
label var transfer_sm "Amount Sent"
label var transfer_sm_2 "Amount Sent Squared"
label var return_share "Return Rate"

**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

quietly: eststo return_1: xttobit return_share sud years_in_PR_norm  transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1) 
quietly: eststo return_2: xttobit return_share sud years_in_PR_norm years_in_PR_norm_X_sud transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1)
**tests on the convergence
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud

* OUTPUT TABLES
cd "../$output_root"
esttab sent_1 sent_2 return_1 return_2 using "table_convergence.rtf", b(3) se(3) label replace
esttab belief_sent_1 belief_sent_2 belief_return_1 belief_return_2 using "table_convergence_beliefs.rtf", b(3) se(3) label replace

* HISTOGRAM OF RESIDENCE INDEX
histogram years_in_PR_norm, xtitle(Years in PR (normalized)) scheme(s1mono)
graph export "hist_years_in_PR_norm.png", as(png) replace
* TABLES 
**have an idea of the sample: 104 obs, equally distributed between non-sud and sud (55 vs 48), members and not (66 vs 39); not really balanced wrt treatment (80 out vs 25 in)
preserve
collapse (mean) sud (mean) membroatt (mean) years_in_PR_norm (mean) ingroup, by(idlungo)
table sud , contents(mean years_in_PR_norm count years_in_PR_norm )
table membroatt, contents(mean years_in_PR_norm count years_in_PR_norm )
table ingroup, contents(mean years_in_PR_norm count years_in_PR_norm )

**compare who replied to call and those who did not
drop if comunen=="PARMA" | comunen=="parma" | provincian == "PR" | provincian == "pr"
gen no_call = 0
replace no_call = 1 if years_in_PR_norm==.
** INSERT HERE THE TESTS

restore

**compare the two samples (all controls vs not)
cd "../Scripts/$data_root"
use data_sender, clear
cd "../$script_root"
run "clean_data_SENT.do"

*UNEXPLAINED values:
drop if exp_sender == 12.5 | exp_sender == 23

preserve
drop if no_call==0
*sud
sum trasferimento if sud , deta
sum ave_return_norm  if sud , deta
sum exp_receiver_norm if sud , deta
sum exp_sender  if sud , deta

*nord
sum trasferimento if sud==0 , deta
sum ave_return_norm  if sud==0 , deta
sum exp_receiver_norm if sud==0, deta
sum exp_sender  if sud==0, deta
restore

*create dummy sud and treatment
quietly: gen sud_X_ingroup = sud*ingroup

global controls "centro sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"
gen missing_controls=0

foreach var of global controls{
replace missing_controls=1 if `var'==.
}
ranksum(eta_g), by(missing_controls )
ranksum(femmina), by(missing_controls )
ranksum(abitanti_gr), by(missing_controls )
ranksum(laurea), by(missing_controls )
ranksum(pensionato), by(missing_controls )
ranksum(nubile), by(missing_controls )
ranksum(sodred_dum), by(missing_controls )
ranksum(trasferimento), by(missing_controls )
ranksum(ave_return_norm), by(missing_controls )

**test if used sample differs in sud variable
ranksum(years_in_PR_norm) if missing_controls==0, by(sud)
**summarize the sample used
preserve
keep $controls missing_controls trasferimento ave_return_norm years_in_PR_norm years_in_PR_norm_X_sud
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
label var years_in_PR_norm "Years in Parma"
label var years_in_PR_norm_X_sud "Years in Parma_X_South"
label var sud "South"
label var centro "Centre"
label var trasferimento "Amount Sent"
label var ave_return_norm "Average Return Rate"


drop if missing_controls==1
sum if sud
cd "$output_root"
asdoc sum, replace dec(2) label save(descriptives_subsample.doc)
restore
