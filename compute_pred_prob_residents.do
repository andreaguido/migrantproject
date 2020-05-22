preserve
gen PR= 0
replace PR = 1 if provincian == "PR"
ologit trasferimento PR exp_sender exp_receiver_norm ave_return_norm $controls, robust
mgen , over(PR)
list _pr0 _pr5 _pr10 _pr15 _pr20 _pr25 PR in 1/2
restore
