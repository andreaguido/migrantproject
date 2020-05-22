**ANALYSIS OF CONVERGENCE**
***************************

** SETTINGS
global data_root "Data"
global output_root "Output"
*********************************************************************************************

****** Section 1.1 *****
****SENDER DECISION*****
************************
cd "$data_root"
use data_sender, clear

cd ..
run "clean_data_SENT.do"

*create dummy sud and treatment
quietly: gen sud_X_ingroup = sud*ingroup

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

eststo clear
*********************************************************************************************
**run the regression
quietly: eststo sent_1: ologit trasferimento sud  years_in_PR_norm exp_sender exp_receiver_norm ave_return_norm $controls, robust
quietly: eststo sent_2: ologit trasferimento sud  years_in_PR_norm years_in_PR_norm_X_sud exp_sender exp_receiver_norm ave_return_norm $controls, robust
*********************************************************************************************
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud
**get margins 
** here run simpliefied model without expectations nor amount returns (average)
quietly: eststo sent_1: ologit trasferimento sud  years_in_PR_norm $controls, robust
mgen , at(years_in_PR_norm  = (0 (.1) 1) sud = 1) stub(south) predn(southpr) replace
mgen , at(years_in_PR_norm  = (0 (.1) 1) sud = 0) stub(nonsouth) predn(nonsouthpr) replace
list southsouthpr0 southsouthpr15 southsouthpr25 nonsouthnonsouthpr0 nonsouthnonsouthpr15 nonsouthnonsouthpr25 southyears_in_PR_norm in 1/11

//line southsouthpr0 southsouthpr15 southsouthpr25 nonsouthnonsouthpr0 nonsouthnonsouthpr15 nonsouthnonsouthpr25 southyears_in_PR_norm, lpattern(l _ _- l _ _-) yline(0.046, lpattern(shortdash) lcolor(gs12)) yline(0.28, lpattern(shortdash) lcolor(gs12)) yline(0.14, lpattern(shortdash) lcolor(gs12)) ///
//name(margins_amount_sent, replace) lcolor("red" "red" "red" "blue" "blue" "blue") legend(label(1 "Prob(S=0|South)") label(2 "Prob(S=15|South)") ///
//label(3 "Prob(S=25|South)") label(4 "Prob(S=0|North)") label(5 "Prob(S=15|North)") label(6 "Prob(S=25|North)")) ytitle("Predicted Probability") xscale(titlegap(*20)) yscale(titlegap(*30)) legend(rows(2) textwidth(45))
//gr export "../$output_root/margins_amount_sent.png", as(png) replace

*create variable with predicted probabilities of sending X € computed using native sample only (see ancillary script)
gen send0PR= 0.046
gen send5PR=0.11
gen send10PR=0.24
gen send15PR=0.28
gen send20PR=0.17
gen send25PR=0.14

twoway (rarea southll0 southul0 southyears_in_PR_norm, color(gs15)) (rarea nonsouthll0 nonsouthul0 southyears_in_PR_norm, color(gs15)) ///
(line send0PR southyears_in_PR, lpattern(_) lcolor(gs12)) (line southsouthpr0 nonsouthnonsouthpr0 southyears_in_PR_norm, yline(0.046, lpattern(shortdash) lcolor(gs12)) ///
name(send0, replace) lcolor("red" "blue") legend(order(4 "Southern Migrants" 5 "Non-Southern Migrants")) xtitle("") ytitle("Predicted Probability") title("Amount Sent = 0") xscale(titlegap(*20)) ///
ylabel(0(.1).6))

twoway (rarea southll5 southul5 southyears_in_PR_norm, color(gs15)) (rarea nonsouthll5 nonsouthul5 southyears_in_PR_norm, color(gs15)) ///
(line send5PR southyears_in_PR, lpattern(_) lcolor(gs12)) (line southsouthpr5 nonsouthnonsouthpr5 southyears_in_PR_norm, yline(0.11, lpattern(shortdash) lcolor(gs12)) ///
name(send5, replace) lcolor("red" "blue") legend(off) xtitle("") xscale(titlegap(*20))  title("Amount Sent = 5") ///
ylabel(0(.1).6))

twoway (rarea southll10 southul10 southyears_in_PR_norm, color(gs15)) (rarea nonsouthll10 nonsouthul10 southyears_in_PR_norm, color(gs15)) ///
(line send10PR southyears_in_PR, lpattern(_) lcolor(gs12)) (line southsouthpr10 nonsouthnonsouthpr10 southyears_in_PR_norm, yline(0.24, lpattern(shortdash) lcolor(gs12)) ///
name(send10, replace) lcolor("red" "blue") legend(off)  xtitle("") xscale(titlegap(*20))  title("Amount Sent = 10") ///
ylabel(0(.1).6))

twoway (rarea southll15 southul15 southyears_in_PR_norm, color(gs15)) (rarea nonsouthll15 nonsouthul15 southyears_in_PR_norm, color(gs15)) ///
(line send15PR southyears_in_PR, lpattern(_) lcolor(gs12)) (line southsouthpr15 nonsouthnonsouthpr15 southyears_in_PR_norm, yline(0.28, lpattern(shortdash) lcolor(gs12)) ///
name(send15, replace) lcolor("red" "blue") legend(off) title("Amount Sent = 15") xtitle("Years in Parma (Normalized)") ytitle("Predicted Probability") xscale(titlegap(*20)) ///
ylabel(0(.1).6))

twoway (rarea southll20 southul20 southyears_in_PR_norm, color(gs15)) (rarea nonsouthll20 nonsouthul20 southyears_in_PR_norm, color(gs15)) ///
(line send20PR southyears_in_PR, lpattern(_) lcolor(gs12)) (line southsouthpr20 nonsouthnonsouthpr20 southyears_in_PR_norm, yline(0.17, lpattern(shortdash) lcolor(gs12)) ///
name(send20, replace) lcolor("red" "blue") legend(off) xtitle("Years in Parma (Normalized)") xscale(titlegap(*20)) title("Amount Sent = 20") ///
ylabel(0(.1).6))

twoway (rarea southll25 southul25 southyears_in_PR_norm, color(gs15)) (rarea nonsouthll25 nonsouthul25 southyears_in_PR_norm, color(gs15)) ///
(line send25PR southyears_in_PR, lpattern(_) lcolor(gs12)) (line southsouthpr25 nonsouthnonsouthpr25 southyears_in_PR_norm, yline(0.14, lpattern(shortdash) lcolor(gs12)) ///
name(send25, replace) lcolor("red" "blue") legend(off) xtitle("Years in Parma (Normalized)") xscale(titlegap(*20)) title("Amount Sent = 25") ///
ylabel(0(.1).6))

grc1leg send0 send5 send10 send15 send20 send25
gr export "../$output_root/margins_amount_sent.png", as(png) replace

* HISTOGRAM OF RESIDENCE INDEX
histogram years_in_PR_norm, xtitle(Years in Parma (normalized)) scheme(s1mono) kdensity kdenopts(gaussian)
graph export "../$output_root/hist_years_in_PR_norm.png", as(png) replace

*** Section 1.2 **
**SENDER BELIEFS**
******************
**run the regression
quietly: eststo belief_sent_1: ologit exp_sender sud years_in_PR_norm trasferimento $controls, robust
quietly: eststo belief_sent_2: ologit exp_sender sud years_in_PR_norm years_in_PR_norm_X_sud trasferimento $controls, robust
*********************************************************************************************
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud
**get margins
mgen , at(years_in_PR_norm  = (0 (.1) 1) sud = 1) stub(expsouth) predn(expsouthpr) replace
mgen , at(years_in_PR_norm  = (0 (.1) 1) sud = 0) stub(expnonsouth) predn(expnonsouthpr) replace
list expsouthexpsouthpr0 expsouthexpsouthpr15 expsouthexpsouthpr25 expnonsouthexpnonsouthpr0 expnonsouthexpnonsouthpr15 expnonsouthexpnonsouthpr25 expsouthyears_in_PR_norm in 1/11
line expsouthexpsouthpr0 expsouthexpsouthpr15 expsouthexpsouthpr25 expnonsouthexpnonsouthpr0 expnonsouthexpnonsouthpr15 expnonsouthexpnonsouthpr25 expsouthyears_in_PR_norm, scheme(sj) name(margins_amount_sent_exp, replace) lcolor("red" "red" "red" "blue" "blue" "blue")
gr export "../$output_root/margins_amount_sent_exp.png", as(png) replace

** Section 2 **
**RECEIVER BELIEFS**
********************
cd "$data_root"
use data_sender, clear

cd ..
run "clean_data_SENT.do"
**create dummy sud and treatment
quietly: gen sud_X_ingroup = sud*ingroup

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"

quietly: eststo belief_return_1: tobit exp_receiver_norm sud years_in_PR_norm ave_return_norm $controls, ll(0) ul(1) robust
quietly: eststo belief_return_2: tobit exp_receiver_norm c.years_in_PR_norm##sud  ave_return_norm $controls, ll(0) ul(1) robust
** get margins from last regression
margins, at(years_in_PR_norm=(0(0.1)1)) by(sud)
marginsplot, name(margins_returnshare_exp, replace) ytitle(Predicted Return Share)
gr export "../$output_root/margins_returnshare_exp.png", as(png) replace

*********************************************************************************************
tobit exp_receiver_norm sud years_in_PR_norm years_in_PR_norm_X_sud ave_return_norm $controls, ll(0) ul(1) robust
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud

** Section 2.2 ******
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
label var years_in_PR_norm_X_sud "Years in Parma X South"
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
quietly: eststo return_2: xttobit return_share c.years_in_PR_norm##sud transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1)
// same as: xttobit return_share sud years_in_PR_norm years_in_PR_norm_X_sud transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1)
** get margins from last regression
quietly: eststo return_1: xttobit return_share sud years_in_PR_norm  transfer_sm $controls, ll(0) ul(1) 
mgen, at(years_in_PR_norm=(0(0.1)1) sud==1) stub(south) replace
mgen, at(years_in_PR_norm=(0(0.1)1) sud==0) stub(north) replace

gen returnPR=0.32
list southxb southll northxb southyears_in_PR in 1/22
twoway  (rarea southll southul southyears_in_PR, color(gs15)) (rarea northll northul northyears_in_PR, color(gs15)) ///
        (line southxb southyears_in_PR, lcolor(red)) (line northxb northyears_in_PR, lcolor(blue)) (line returnPR southyears_in_PR, lpattern(_)), legend(order(3 "Southern" 4 "Non-Southern")) xtitle(Years in Parma (Normalized)) ytitle(Predicted Return Rate)
gr export "../$output_root/margins_return_rate.png", as(png) replace

margins, at(years_in_PR_norm=(0(0.1)1)) by(sud)
marginsplot, name(margins_returnshare, replace)
gr export "../$output_root/margins_returnshare.png", as(png) replace
gr combine margins_returnshare margins_returnshare_exp, name(combined_convergence, replace)
gr export "../$output_root/margins.png", as(png) replace

**tests on the convergence
xttobit return_share sud years_in_PR_norm years_in_PR_norm_X_sud transfer_sm transfer_sm_2 exp_sender exp_receiver_norm $controls, ll(0) ul(1)
lincom years_in_PR_norm + years_in_PR_norm_X_sud
test years_in_PR_norm years_in_PR_norm_X_sud

* OUTPUT TABLES
cd "../$output_root"
esttab sent_1 sent_2 return_1 return_2 using "table_convergence.rtf", b(3) se(3) label replace
esttab belief_sent_1 belief_sent_2 belief_return_1 belief_return_2 using "table_convergence_beliefs.rtf", b(3) se(3) label replace

* TABLES 
**have an idea of the sample: 105 obs, equally distributed between non-sud and sud (55 vs 48), members and not (66 vs 39); not really balanced wrt treatment (80 out vs 25 in)
cd "../Scripts/$data_root"
use data_sender, clear
cd "../$script_root"
run "clean_data_SENT.do"
table sud , contents(mean years_in_PR_norm count years_in_PR_norm )
table membroatt, contents(mean years_in_PR_norm count years_in_PR_norm )
table ingroup, contents(mean years_in_PR_norm count years_in_PR_norm )

**compare who replied to call and those who did not
drop if comunen=="PARMA" | comunen=="parma" | provincian == "PR" | provincian == "pr"
gen no_call = 0
replace no_call = 1 if years_in_PR_norm==.
** tests
ttest eta , by(no_call)
ttest disocc, by(no_call)
ttest risfin, by(no_call)
ttest soddsalute, by(no_call)
ttest freqrel, by(no_call)
ttest trasferimento , by(no_call)
ttest ave_return_norm, by(no_call)
ttest return_0_norm, by(no_call)
ttest return_5_norm, by(no_call)
ttest return_10_norm, by(no_call)
ttest return_15_norm, by(no_call)
ttest return_20_norm, by(no_call)

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

global controls "sud_X_ingroup ingroup membroatt membrosolopass femmina eta_g eta_g_2 sodred_dum abitanti_gr laurea superiore pensionato nucleo nubile figlio_unico credente pratic_culto divorziato soddsalute risfin errori experimenter"
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

** GRAPHS **
label define south 0 "Non-Southerners" 1 "Southerners"
label var sud south
twoway (lfitci trasferimento years_in_PR_norm) (scatter trasferimento years_in_PR_norm),ytitle(Amount Sent)  by(, legend(off) note("") title(Panel A)) by(sud) name(sent, replace)
twoway (lfitci ave_return_norm years_in_PR_norm) (scatter ave_return_norm years_in_PR_norm), ytitle(Avg. Return Rate) by(, legend(off) note("") title(Panel B)) by(sud) name(return, replace)
twoway (lfitci exp_sender years_in_PR_norm) (scatter exp_sender years_in_PR_norm),ytitle(Amount Sent Exp.) by(, legend(off) note("") title(Panel C)) by(sud) name(exp_sent, replace)
twoway (lfitci exp_receiver_norm years_in_PR_norm) (scatter exp_receiver_norm years_in_PR_norm),ytitle(Return Rate Exp.) by(, note("") legend(off) title(Panel D)) by(sud) name(exp_return, replace)
gr combine sent return exp_sent exp_return, name(combined_convergence, replace)
gr export "../$output_root/combined_convergence.png", as(png) replace

