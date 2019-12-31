global data_root "Data"
global output_root "Output"


cd "$data_root"
use data_sender, clear

cd ..
run "clean_data_SENT.do"

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
label var exp_receiver_norm "Return Rate Exp."
label var sud "South"
label var centro "Centre"
label var trasferimento "Amount Sent"
label var ave_return_norm "Average Return Rate"
label var exp_sender "Amount Sent Exp."

******************EXPECTATIONS on RECEIVER****************************
eststo clear

* Basic impact of south
eststo: tobit exp_receiver_norm sud $controls , ll(0) ul(1) robust
eststo: tobit exp_receiver_norm sud sud_X_ingroup $controls , ll(0) ul(1) robust
eststo: tobit exp_receiver_norm sud ave_return_norm $controls , ll(0) ul(1) robust
eststo: tobit exp_receiver_norm sud sud_X_ingroup ave_return_norm $controls , ll(0) ul(1) robust

cd ..
cd "$output_root"
esttab using "table_beliefs_on_receiver.rtf", b(3) se(3) label replace

*****************CHECK OF EXPERIMENTER EFFECT***********************
gen South_X_Experimenter = sud*experimenter
eststo: tobit exp_receiver_norm sud sud_X_ingroup ave_return_norm South_X_Experimenter $controls , ll(0) ul(1) robust

******************REGS: EFFECTs OF SOUTH VAR ON SENDING****************************
cd ..
cd "scripts"
cd "$data_root"
use data_receiver, clear

cd ..
run "clean_data_RET.do"

* Models basic without interaction effect for RETURN RATE
xtset  idlungo  dec_num
eststo clear

**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

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
label var return_share "Return rate"
label var transfer_sm "Amount Sent"
label var transfer_sm_2 "Amount Sent Sq."
label var exp_receiver_norm "Return Rate Exp."

* Basic impact of south
eststo: xttobit return_share sud $controls, ll(0) ul(1)

* Impact of beliefs: south effect disappears!
eststo: xttobit return_share sud transfer_sm transfer_sm_2 $controls, ll(0) ul(1)
eststo: xttobit return_share sud exp_sender $controls, ll(0) ul(1)
eststo: xttobit return_share sud exp_receiver_norm $controls, ll(0) ul(1)
eststo: xttobit return_share sud transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1)

cd "../$output_root"
esttab using "table_amount_ret.rtf", label b(3) se(3) replace


**SOBEL-GOODMAN MEDIATION ANALYSIS
*One variable at a time:
*Exp on Senders
sgmediation return_share, iv(sud) mv(exp_sender) cv($controls) quietly
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation return_share, iv(sud) mv(exp_sender) cv($controls) 
*Exp on Receiver
sgmediation return_share, iv(sud) mv(exp_receiver_norm) cv($controls) quietly
bootstrap r(ind_eff) r(dir_eff), reps (1000): sgmediation return_share, iv(sud) mv(exp_receiver_norm) cv($controls) 

*All variables:
*Exp on Senders
sgmediation return_share, iv(sud) mv(exp_sender) cv(exp_receiver_norm  $controls) quietly
*Exp on Receiver
sgmediation return_share, iv(sud) mv(exp_receiver_norm) cv(exp_sender  $controls) quietly

eststo clear

*DECISIONS
cd "$data_root"
use data_receiver, clear
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


run "clean_data_RET.do"
xtset  idlungo  dec_num
**create dummy sud and treatment
gen sud_X_ingroup = sud*ingroup

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

eststo: xttobit return_share sud years_in_PR_norm  $controls, ll(0) ul(1) 
eststo: xttobit return_share sud years_in_PR_norm years_in_PR_norm_X_sud $controls, ll(0) ul(1)

cd "$output_root"
esttab using "table_receiver_decision_beliefs_convergence.rtf", label r2 ar2 replace
