global data_root "C:/Users/andrea.guido/Dropbox (ETHICS)/projects/Southern Migrants/Data"
global script_root "C:/Users/andrea.guido/Dropbox (ETHICS)/projects/Southern Migrants/Scripts"
global output_root "C:/Users/andrea.guido/Dropbox (ETHICS)/projects/Southern Migrants/Output"

**SENDER DECISIONS
cd "$data_root"
use data_sender, clear

cd "$script_root"
run "clean_data_SENT.do"

**UNEXPLAINED values:
drop if exp_sender == 12.5 | exp_sender == 23

**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

eststo clear

**SENDER DECISION
**run the regression
eststo sent_1: ologit trasferimento sud  years_in_PR_norm exp_sender exp_receiver_norm ave_return_norm $controls, robust
eststo sent_2: ologit trasferimento sud  years_in_PR_norm years_in_PR_norm_X_sud exp_sender exp_receiver_norm ave_return_norm $controls, robust

**SENDER BELIEFS
**run the regression
eststo belief_sent_1: ologit exp_sender sud years_in_PR_norm trasferimento $controls, robust
eststo belief_sent_2: ologit exp_sender sud years_in_PR_norm years_in_PR_norm_X_sud trasferimento $controls, robust

**RECEIVER BELIEFS
cd "$data_root"
use data_sender, clear

cd "$script_root"
run "clean_data_SENT.do"
**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"
eststo belief_return_1: tobit exp_receiver_norm sud years_in_PR_norm $controls, ll(0) ul(1) robust
eststo belief_return_2: tobit exp_receiver_norm sud years_in_PR_norm years_in_PR_norm_X_sud $controls, ll(0) ul(1) robust

**RECEIVER DECISIONS
cd "$data_root"
use data_receiver, clear

cd "$script_root"
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
**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

eststo return_1: xttobit return_share sud years_in_PR_norm  transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1) 
eststo return_2: xttobit return_share sud years_in_PR_norm years_in_PR_norm_X_sud transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1)

cd "$output_root"
esttab sent_1 sent_2 return_1 return_2 using "table_convergence.rtf", label r2 ar2 replace
esttab belief_sent_1 belief_sent_2 belief_return_1 belief_return_2 using "table_convergence_beliefs.rtf", label r2 ar2 replace

