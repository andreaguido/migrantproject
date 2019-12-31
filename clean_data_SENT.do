* BBSK: Creating labels
set more off

drop if idcorto==587
drop if idcorto==547


* Creazione / correzioni di variabili attese

**Correct errors in the data:
* A subject had given an unfeasible return, so corrected this.

replace return_5=35 if idcorto==119

* Most likely subject 574 and 560 inverted sender/receiver expectation. going to correct. Note that 560 gets wrong his expected amount return because he only transferred 15.

replace exp_sender=25 if idcorto==560

replace exp_receiver_i=55 if idcorto==560

replace exp_sender=15 if idcorto==574

replace exp_receiver_i=35 if idcorto==574

* subject 603 has unfeasible value. Bring it down to highest possible value (25)
replace exp_sender=25 if idcorto==603

* Subjects has some unfeasible values in receiver expectation, too.

 replace  exp_receiver_i=45 if idcorto==115
replace  exp_receiver_i=55 if idcorto==163

* geographical corrections
replace centro = 0 if idlungo == 82229
replace nord = 1 if idlungo == 82229
replace sud = 1 if idlungo == 102248
replace centro = 0 if idlungo == 102248
replace sud = 1 if idlungo == 1122258
replace centro = 0 if idlungo == 1122258

gen exp_receiver_norm =  exp_receiver_i/(2*trasferimento+25)

** Normalizzazione amount sent

. gen  return_0_norm =  return_0/25

. gen  return_5_norm =  return_5/35

. gen  return_10_norm =  return_10/45

. gen  return_15_norm =  return_15/55

. gen  return_20_norm =  return_20/65

. gen  return_25_norm =  return_25/75

** creazione var alternative sud

gen sud_istat = sud
replace sud_istat = 1 if sardinia==1



gen sud_putnam = sud
replace sud_putnam = 1 if sardinia==1 | lazio==1


* correzione studio

drop superiore
gen superiore = studio==5
replace superiore=. if studio==.



*Creazione figlio unico

gen figlio_unico =  n_fratelli_g==0

replace figlio_unico = . if  n_fratelli_g==.

* Creazione professione
gen occ_prof = profes <3
gen occ_imp = profes >=3 & profes <7
gen occ_ope = profes >= 7 & profes<.
replace occ_prof=. if profes==.
replace occ_imp=. if profes==.
replace occ_ope=. if profes==.

* Creazione disoccupato dummy
gen disocc = idcorto== 132 | idcorto== 158 | idcorto== 152  | idcorto== 171  | idcorto== 180  | idcorto== 517 | idcorto== 514 | idcorto== 212 | idcorto== 592 | idcorto== 820 | idcorto== 701

* Creazione pensionato dummy
gen pensionato = idcorto==125 | idcorto==129 | idcorto==111 | idcorto==115 | idcorto==116 | idcorto==110 | idcorto==104 | idcorto==138 | idcorto==127 | idcorto==113 | idcorto==102 | idcorto==112 | idcorto==154 | idcorto==184 | idcorto==124 | idcorto==107 | idcorto==218 | idcorto==206 | idcorto==210 | idcorto==205 | idcorto==211 | idcorto==204 | idcorto==237 | idcorto==246 | idcorto==284 | idcorto==289 | idcorto==270 | idcorto==280 | idcorto==272 | idcorto==534 | idcorto==508 | idcorto==230 | idcorto==504 | idcorto==559 | idcorto==249 | idcorto==554 | idcorto==503 | idcorto==558 | idcorto==568 | idcorto==627 | idcorto==604 | idcorto==644 | idcorto==241 | idcorto==664 | idcorto==653 | idcorto==651 | idcorto==704 | idcorto==647 | idcorto==718 | idcorto==702 | idcorto==632 | idcorto==649 | idcorto==719 | idcorto==711 | idcorto==623 | idcorto==721 | idcorto==640 | idcorto==587 | idcorto==622 | idcorto==620 | idcorto==803 | idcorto==826 | idcorto==831 | idcorto==665 

* Creazione studente
gen studente = idcorto== 103 | idcorto==168 | idcorto==170 | idcorto==160 | idcorto==105 | idcorto==131 | idcorto==242 | idcorto==268 | idcorto==286 | idcorto==209 | idcorto==515 | idcorto==526 | idcorto==505 | idcorto==546 | idcorto==506 | idcorto==588 | idcorto==589 | idcorto==615 | idcorto==662 | idcorto==650 | idcorto==654 | idcorto==808

gen ln_redd = ln(reddito_agg)
gen ln_redd_corr =ln(reddito_agg/nucleo)


* Creazione praticante (va in chiesa almeno qualche volta al mese)
gen pratic_culto=freqrel>2 & freqrel<.
replace  pratic_culto=. if freqrel==.

* Creazione scale fiducia

alpha   prestgenitori prestamici prestcolleghi prestvicini ricgenitori ricamici riccolleghi ricvicini denam fidporta fidbici fidoggetti fidnoncon benefici, gen (past_trust_trustworth) std det i
alpha   prestgenitori prestamici prestcolleghi prestvicini denam fidporta fidbici fidoggetti fidnoncon , gen (past_trust) std
alpha   prestgenitori prestamici prestcolleghi prestvicini denam , gen (past_trust_person) std
alpha    fidporta fidbici fidoggetti fidnoncon , gen (past_trust_imp) std

alpha   ricgenitori ricamici riccolleghi ricvicini benefici, gen(past_trustworth) std
alpha   ricgenitori ricamici riccolleghi ricvicini , gen(past_trustworth_pers) std

alpha giustbenpub giustbigl giusttasse , gen (civic_norm_ind)std
alpha contrcalamita contrdonazioni  contrelemosina , gen (generosity_index) std

* Creazione dummy per sodred e sodsalute

gen sodred_dum = sodred<3
replace  sodred_dum=. if sodred==.

gen soddsalute_dum = soddsalute>3
replace  soddsalute_dum=. if soddsalute==.


* sistemo la variabile per errori nei test

gen t1_err= t1!=25

gen t2_err=t2!=25

gen t3_err=t3!=10

gen t4_err=t4!=60

gen t5_err=t5!=35

gen t6_err=t6!=40

gen errori= t1_err+t2_err+t3_err+t4_err+t5_err+t6_err


replace errori = . if t1==.& t2==.& t3==.&t4==.&t5==.& t6==.



* drop unnecessary vars
drop member_now member_past nonmembro

* drop unused vars
*drop  servmesi3 relimesi3 cultumesi3 sportmesi2 sportmesi3 ambmesi4 sindmesi3 catmesi2 catmesi3 giovmesi3 edumesi2 edumesi3 femmmesi1 femmmesi2 femmmesi3 pacemesi1 pacemesi2 pacemesi3 salutmesi5 protcmesi2  protcmesi3 prelimesi2  pcultumesi3 pambmesi3 ppolmesi2 ppolmesi3 ppovermesi2 ppovermesi3 pcatmesi2 pcatmesi3 pgiovmesi3 pedumesi2 pedumesi3 pfemmmesi2 pfemmmesi3 ppacemesi3 psalutmesi3 pprotcmesi2 pprotcmesi3
rename pslutdummy psalutdummy

* Creation association type var; NB: I membri attuali reclutati da Demosk (a parte 2) non sono assegnati in questo modo.

gen association_type = 1 if association==1 | association==2 | association==3 | association==4
replace association_type = 2 if association==5 | association==6 | association==7 |  association==8
replace association_type = 3 if association==9 | association==10 
replace association_type = 0 if association==0 


replace gruppo=0 if gruppo==2



* Creo dummmy-associazione
gen association_0 = association==0
gen association_1 = association==1
gen association_2 = association==2
gen association_3 = association==3
gen association_4 = association==4
gen association_5 = association==5
gen association_6 = association==6
gen association_7 = association==7
gen association_8 = association==8
gen association_9 = association==9
gen association_10 = association==10
gen association_11 = association==11

* generate unclear variable; 20 valori mancanti!

gen unclear=chiare<5
replace unclear=. if chiare==.

* generate age squared
gen eta_g_2 = eta_g^2

gen ingroup=1-outgroup



* Create interaction terms: Elimino No_memb (mai usato in reg seguenti).

gen ass_cult = association_type==1
gen ass_soc = association_type==2
gen ass_trade = association_type==3

gen cult_X_out =  ass_cult*outgroup
gen soc_X_out =  ass_soc*outgroup
gen trade_X_out =  ass_trade*outgroup

gen cult_X_in =  ass_cult*ingroup
gen soc_X_in =  ass_soc*ingroup
gen trade_X_in =  ass_trade*ingrou



gen association_0_X_ing= association_0*ingroup
gen association_0_X_out= association_0*outgroup

gen association_1_X_ing= association_1*ingroup
gen association_1_X_out= association_1*outgroup

gen association_2_X_ing= association_2*ingroup
gen association_2_X_out= association_2*outgroup

gen association_3_X_ing= association_3*ingroup
gen association_3_X_out= association_3*outgroup


gen association_4_X_ing= association_4*ingroup
gen association_4_X_out= association_4*outgroup

gen association_5_X_ing= association_5*ingroup
gen association_5_X_out= association_5*outgroup

gen association_6_X_ing= association_6*ingroup
gen association_6_X_out= association_6*outgroup

gen association_7_X_ing= association_7*ingroup
gen association_7_X_out= association_7*outgroup

gen association_8_X_ing= association_8*ingroup
gen association_8_X_out= association_8*outgroup

gen association_9_X_ing= association_9*ingroup
gen association_9_X_out= association_9*outgroup

gen association_10_X_ing= association_10*ingroup
gen association_10_X_out= association_10*outgroup

 gen exp_receiver_norm_X_att= exp_receiver_norm*membroatt
gen exp_receiver_norm_X_att_in = exp_receiver_norm*membroatt*ingroup
gen exp_receiver_norm_X_att_out = exp_receiver_norm*membroatt*outgroup
rename  exp_sender_i exp_sender

 gen exp_sender_X_att =  exp_sender*membroatt


gen exp_sender_X_att_in =  exp_sender*membroatt*ingroup


gen exp_sender_X_att_out =  exp_sender*membroatt*outgroup




* Inserisco valori mancanti per i soggetti che sono stati reclutati per alcune associazione, ma che hanno lasciato in bianco la parte del questionario rispetto all'appartenenza.

replace sindnum=1 if idcorto==238 |   idcorto==572 |  idcorto==512  | idcorto==599
replace sinddummy=1 if idcorto==238 |   idcorto==572 |  idcorto==512  | idcorto==599
replace sindqua=1 if idcorto==238 |   idcorto==572 |  idcorto==512  | idcorto==599


replace cultunum=1 if idcorto==125 |   idcorto==128
replace cultudummy=1 if idcorto==125 |   idcorto==128
replace cultuqua=1 if idcorto==125 |   idcorto==128


* Attribuisco valori mancanti di membropass (vedi log). Prima genero 2 variabili che sommano il numero di associazioni di cui uno e' stato membro o attualmente o in passato: ASSATOTNUM ASSATOTNUMPAS

generate assatotnum= servqua+ reliqua+ cultuqua+ sportqua+ ambqua+ sindqua+ polqua+ poverqua+ catqua+ gioqua+ eduqua+ femmqua+ pacequa+ salutqua+  protnum
generate assatotnumpas= pservqua+ preliqua+ pcultuqua+ psportqua+ pambqua+ psindqua+ ppolqua+ ppoverqua+ pcatqua+ pgioqua+ peduqua+ pfemmqua+ ppacequa+ psalutqua+ pprotqua


replace assatotnum=. if membroatt==1 & assatotnum==0

* Qui suppongo che se uno non dichiara nessuna associazione passata NON e' stato membro in passato (si eliminano 23 valori mancanti).

replace membropass=0 if  assatotnumpas==0 & membropass==.

* Questo e' il corista che ha lasciato in bianco tutto il questionario
replace membropass=. if idcorto==128

* Costruisco variabile per chi non e' mai stato membro: MEMBROMAI
gen membromai = membroatt==0 & membropass==0
replace membromai =. if membropass==. & membroatt==.


* costruisco una variabile che è =1 se uno è membro oggi o lo è stato in passato: MEMBROALMENO (identico a membroalmeno, ora tolto; 5-4-12 eliminato membroalmeno completamente, era ancora presente in alcune def.).
gen membroalmeno = membroatt==1 | membropass==1
replace membroalmeno=. if membroatt==. & membropass==.

*costruisco variabili dummy per chi è membro solo attualmente, lo è stato solo in passato, lo è sia ora sia lo è stato in passato: MEMBROSOLOORA
gen membrosoloora=  membroatt==1 & membropass==0
replace  membrosoloora=. if membropass==. | membroatt==.

* MEMBROSOLOPASS


gen  membrosolopass = membroatt==0 & membropass==1
replace  membrosolopass=. if membropass==. & membroatt==0

* MEMBROORAEPOI: Membro ora e abbandonato associazioni in passato

gen membrooraepoi= membroatt==1 & membropass==1
replace membrooraepoi=. if membropass==. | membroatt==.

*costruisco una variabile di interazione fra le dummy su chi ha smesso di fare il volontario e il numero di anni da cui ha smesso

gen membrosolopassint = membrosolopass*annismesso
replace  membrosolopassint=0 if  annismesso==.

* estensione annismesso 

replace annismesso=0 if membroatt==1 | membromai==1
gen dum_annismesso = annismesso>0
replace dum_annismesso =. if annismesso==.


* genero una variabile dummy per assatotnum 
***********************************************
*HERE I DELETE ALL VARS RELATED WITH ASSOCIATION ENGAGEMENT
**********************************************

* creo le variabili di interazione fra outgroup e ingroup e le mie variabili chiave su cui faccio le stime
*ricordarsi che bisogna verificare che tutti quelli che hanno messo 1 in memrboatt abbiano anche un valore positivo (e non 0) nelle variabili di numerod i associazioni e ore passate in associazione
* ossia devo avere 3 gruppi di soggetti: quelli che prendono valori diversi da 0 nell'interazione con ingroup devono essere tutti volontari, quelli che prendono diverso da 0 nell'outgroup anche, così la variabile residuale sono i non membri 



generate membroatt_X_out=membroatt*outgroup
generate membroatt_X_in=membroatt*ingroup

generate membroalmeno_X_out=membroalmeno*outgroup
generate membroalmeno_X_in=membroalmeno*ingroup

generate membromai_X_out=membromai*outgroup
generate membromai_X_in=membromai*ingroup

generate membrosoloora_X_out=membrosoloora*outgroup
generate membrosoloora_X_in=membrosoloora*ingroup

generate membrosolopass_X_out=membrosolopass*outgroup
generate membrosolopass_X_in=membrosolopass*ingroup

generate membrooraepoi_X_out=membrooraepoi*outgroup
generate membrooraepoi_X_in=membrooraepoi*ingroup

generate membrosolopassint_X_outgroup=membrosolopassint*outgroup
generate membrosolopassint_X_ingroup=membrosolopassint*ingroup



* Qui ho trasportato alcune vars che serviranno piu`tardi (non tutte pero')


gen membroatt_out=membroatt*outgroup


* LABELS

label define Association_names 0 "Non-Memb." 1 "C1" 2 "C2" 3 "C3" 4 "C4" 5 "SW1" 6 "SW2" 7 "SW3" 8 "SW4" 9 "TU1" 10 "TU2"

label values association Association_names

label variable trasferimento "Giving rate"

gen giving_rate=trasferimento/25

label variable giving_rate "Giving rate"

label define Outgroup 0 "Ingroup" 1 "Outgroup"
label define membroatt 0 "Non-members" 1 "Members"
label values outgroup Outgroup
label values membroatt membroatt

label define Ingroup 0 "Outgroup" 1 "Ingroup"
label values ingroup Ingroup

. gen subject_type=0

. replace subject_type=1 if membrosolopass==1
. replace subject_type=2 if membroatt==1

. label define subject_type 0 "Never-Members" 1 "Dropouts" 2 "Members"

. label values subject_type subject_type

. move  subject_type outgroup


. label define Association_type 0 "Non-Members" 1 "Cultural" 2 "Social Welfare" 3 "Trade Unions"

. label values association_type Association_type


* Creation of return index = average of return rates over 6 possible transfer levels.

egen ave_return_norm = rowmean( return_0_norm return_5_norm return_10_norm return_15_norm return_20_norm return_25_norm)
* creation of trust in institutions index
egen trustinst = rowmean (trustbanc trustscuola trustpart truststampa trustimpr rtrustorg trustsanita trustordine trustgiust)


* varlist for descriptive
* Var list 

* trasferimento return_0 return_5 return_10 return_15 return_20 return_25 membroatt membrosolopass femmina eta_g sodred_dum sud abitanti_gr laurea superiore pensionato disocc nucleo nubile figlio_unico credente pratic_culto  divorziato soddsalute risfin errori experimenter volannitutti_perc voloreatttutti assatotnum trust 


*************************************************************************
* Commands for analysis of impact of "years in Parma" on Sending rate
*************************************************************************

gen years_in_PR = . 

replace years_in_PR=1995 if idcorto==584
replace years_in_PR=2006 if idcorto==501
replace years_in_PR=1980 if idcorto==212
replace years_in_PR=1988 if idcorto==216
replace years_in_PR=1966 if idcorto==503
replace years_in_PR=1989 if idcorto==264
* è nata in provincia di parma, la proto segnala come anno di trasferimento l'anno di nascita. non so se si è trasferita subito in città o se vive ancora in provincia, se teniamo insieme provincia e città è irrilevanete replace years_in_PR=1937 if idcorto==241
replace years_in_PR=1988 if idcorto==594
* è nata in provincia di parma, la proto segnala come anno di trasferimento l'anno di nascita. non so se si è trasferita subito in città o se vive ancora in provincia, se teniamo insieme provincia e città è irrilevanete replace  years_in_PR=1956 if idcorto==611
replace years_in_PR=1994 if idcorto==637
replace years_in_PR=1998 if idcorto==642
replace years_in_PR=1958 if idcorto==664
* nato in provincia di parma poi trasferitosi in citta replace years_in_PR=1993 if idcorto==641
replace years_in_PR=1986 if idcorto==643
replace years_in_PR=1980 if idcorto==621
replace years_in_PR=1983 if idcorto==708
replace years_in_PR=1983 if idcorto==707
replace years_in_PR=1989 if idcorto==121
replace years_in_PR=2002 if idcorto==132
replace years_in_PR=1993 if idcorto==146
replace years_in_PR=1995 if idcorto==153
replace years_in_PR=2006 if idcorto==103

replace years_in_PR=1990 if idcorto==101
* MOLTO IMPORTANTE: IL PRECEDENTE NON AVEVA EVIDENTEMENTE RISPOSTO ALLA DOMANDA SUL QUESTIONARIO DEL LUOGO DI NASCITA. VALORE MISSING NEL DATASET. POSSIAMO INTEGRARLO CON QUESTO DATO DELLA PROTO: INFATTI E' L'UNICA CHE PUO AVERE QUESTI VALORI E E' QUINDI DI LECCE

replace years_in_PR=2000 if idcorto==159
replace years_in_PR=1980 if idcorto==182
replace years_in_PR=2002 if idcorto==165
replace years_in_PR=1970 if idcorto==206
replace years_in_PR=1997 if idcorto==207
replace years_in_PR=1983 if idcorto==208
replace years_in_PR=1985 if idcorto==220
replace years_in_PR=1990 if idcorto==232
replace years_in_PR=2005 if idcorto==166
replace years_in_PR=1972 if idcorto==224
replace years_in_PR=1985 if idcorto==250
replace years_in_PR=2011 if idcorto==256
replace years_in_PR=1987 if idcorto==258
replace years_in_PR=2007 if idcorto==261
replace years_in_PR=1980 if idcorto==234
replace years_in_PR=1983 if idcorto==263
replace years_in_PR=1979 if idcorto==265
replace years_in_PR=1979 if idcorto==267
replace years_in_PR=1997 if idcorto==532
replace years_in_PR=2006 if idcorto==505
replace years_in_PR=2004 if idcorto==228
replace years_in_PR=2009 if idcorto==106
replace years_in_PR=1992 if idcorto==107
replace years_in_PR=2003 if idcorto==108
* attenzione: si è trasferita da Milano alla provincia di piacenza non parma, io la toglierei replace years_in_PR=2006 if idcorto==109
replace years_in_PR=1965 if idcorto==115
* questa inizialmente si è traferita in provincia di parma poco alla volta in città, la data del 1953 fa riferimento al primo trasferimento, quello nel comune non so a quando risalga replace years_in_PR=1953 if idcorto==116
replace years_in_PR=2006 if idcorto==119
replace years_in_PR=1964 if idcorto==130
replace years_in_PR=1998 if idcorto==137
replace years_in_PR=1981 if idcorto==141
* in realtà vive in provincia di parma replace years_in_PR=2001 if idcorto==142
replace years_in_PR=1975 if idcorto==147
replace years_in_PR=2004 if idcorto==148
replace years_in_PR=1946 if idcorto==154
replace years_in_PR=1969 if idcorto==163
replace years_in_PR=1980 if idcorto==164
replace years_in_PR=1994 if idcorto==171
replace years_in_PR=1965 if idcorto==176
replace years_in_PR=2009 if idcorto==177
replace years_in_PR=1986 if idcorto==179
replace years_in_PR=1982 if idcorto==204
replace years_in_PR=1968 if idcorto==218
replace years_in_PR=2008 if idcorto==223
replace years_in_PR=1978 if idcorto==227
replace years_in_PR=1981 if idcorto==236
replace years_in_PR=1985 if idcorto==237
replace years_in_PR=1992 if idcorto==238
replace years_in_PR=2011 if idcorto==239
* in realtà vive in provincia di parma non proprio a parma replace years_in_PR=1960 if idcorto==240
replace years_in_PR=2006 if idcorto==246
replace years_in_PR=1993 if idcorto==248
replace years_in_PR=2006 if idcorto==262
* 1969 è il primo anno in cui è arrivata qui, poi ripartita ancora nel 1990 e tornata nel 2009 replace years_in_PR=1969 if idcorto==276
replace years_in_PR=1996 if idcorto==277
replace years_in_PR=2004 if idcorto==281
replace years_in_PR=1978 if idcorto==282
replace years_in_PR=1970 if idcorto==290
replace years_in_PR=1989 if idcorto==295
replace years_in_PR=2001 if idcorto==502
replace years_in_PR=1964 if idcorto==507
replace years_in_PR=1989 if idcorto==509
replace years_in_PR=1974 if idcorto==512
replace years_in_PR=1976 if idcorto==516
replace years_in_PR=1995 if idcorto==517
replace years_in_PR=1999 if idcorto==524
replace years_in_PR=2009 if idcorto==525
replace years_in_PR=1974 if idcorto==529
replace years_in_PR=1961 if idcorto==530
replace years_in_PR=1984 if idcorto==537
replace years_in_PR=1969 if idcorto==539
replace years_in_PR=2004 if idcorto==543
replace years_in_PR=1971 if idcorto==554
replace years_in_PR=2000 if idcorto==561
replace years_in_PR=1978 if idcorto==565
replace years_in_PR=2003 if idcorto==569
replace years_in_PR=1986 if idcorto==570
replace years_in_PR=2007 if idcorto==572
replace years_in_PR=1974 if idcorto==575
replace years_in_PR=1990 if idcorto==598
replace years_in_PR=1996 if idcorto==599
replace years_in_PR=1974 if idcorto==607
replace years_in_PR=1995 if idcorto==614
replace years_in_PR=2000 if idcorto==626
replace years_in_PR=2004 if idcorto==655
replace years_in_PR=2004 if idcorto==659
replace years_in_PR=2008 if idcorto==662
replace years_in_PR=1976 if idcorto==706
replace years_in_PR=1969 if idcorto==806
replace years_in_PR=2002 if idcorto==818
replace years_in_PR=1988 if idcorto==825
replace years_in_PR=1986 if idcorto==828

rename years_in_PR migration_year

gen years_in_PR = 2011- migration_year

gen years_in_PR_norm = years_in_PR/  eta_g

gen years_in_PR_norm_X_sud = years_in_PR_norm*sud

* Creation of median split dummy

gen years_in_PR_norm_dum = years_in_PR_norm>.4613095 & years_in_PR_norm<.

gen years_in_PR_norm_dum1 = years_in_PR_norm>.2708333 & years_in_PR_norm<.

**UNEXPLAINED values:
drop if exp_sender == 12.5 | exp_sender == 23
