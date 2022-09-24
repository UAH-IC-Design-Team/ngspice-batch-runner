v {xschem version=3.1.0 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 90 -240 90 -220 {
lab=GND}
N 190 -240 190 -220 {
lab=GND}
N 290 -240 290 -220 {
lab=GND}
N 500 -210 500 -190 {
lab=#net1}
N 500 -130 500 -110 {
lab=Vs}
N 490 -110 500 -110 {
lab=Vs}
N 500 -160 510 -160 {
lab=Vs}
N 510 -160 510 -130 {
lab=Vs}
N 500 -130 510 -130 {
lab=Vs}
N 450 -160 460 -160 {
lab=Vg}
N 490 -290 500 -290 {
lab=Vd}
N 500 -290 500 -270 {
lab=Vd}
C {devices/title.sym} 160 30 0 0 {name=l1 author="Micah Tseng"
}
C {devices/code.sym} 40 -150 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="*.lib $::SKYWATER_MODELS/sky130.lib.spice tt
.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice
"
spice_ignore=false}
C {devices/vsource.sym} 90 -270 0 0 {name=Vd value="1.8V"
}
C {devices/gnd.sym} 90 -220 0 0 {name=l14 lab=GND}
C {devices/lab_pin.sym} 90 -300 0 0 {name=l15 sig_type=std_logic lab=Vd
}
C {devices/vsource.sym} 190 -270 0 0 {name=Vs value=0
}
C {devices/gnd.sym} 190 -220 0 0 {name=l16 lab=GND}
C {devices/lab_pin.sym} 190 -300 0 0 {name=l17 sig_type=std_logic lab=Vs
}
C {sky130_fd_pr/nfet_01v8.sym} 480 -160 0 0 {name=M1
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/ammeter.sym} 500 -240 0 0 {name=vids
}
C {devices/vsource.sym} 290 -270 0 0 {name=Vg value=0
}
C {devices/gnd.sym} 290 -220 0 0 {name=l1 lab=GND}
C {devices/lab_pin.sym} 290 -300 0 0 {name=l2 sig_type=std_logic lab=Vg
}
C {devices/lab_pin.sym} 490 -110 0 0 {name=l3 sig_type=std_logic lab=Vs
}
C {devices/lab_pin.sym} 450 -160 0 0 {name=l4 sig_type=std_logic lab=Vg
}
C {devices/lab_pin.sym} 490 -290 0 0 {name=l5 sig_type=std_logic lab=Vd
}
C {sky130_fd_pr/corner.sym} 170 -150 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/simulator_commands.sym} 60 -520 0 0 {name="ngspice"
value="
* ngspice commands
.options list acct opts
.control

* Go to the const plot
setplot const

echo
echo AWS Iterator = $iterator
echo

let iter_shift = 0.5
let vg_val = 0 + $iterator * $&iter_shift
let vstart = $&vg_val
let vmax = $&iter_shift + $iterator * $&iter_shift
let vdelta = 0.1
let total_runs = ceil(($&vmax - $&vg_val) / $&vdelta)
let runs = 0 + $iterator * $&total_runs
let runs_start = $&runs

* Insert vector names and set only one scale
set wr_vecnames
set wr_singlescale

* set the hcopy type
set hcopydevtype=svg


while vg_val lt $&vmax
	* Alter the voltages
	alter vg vg_val

	dc vd 0 1.8 10e-3

	set plotfile0 = plot_mos_\{$&runs\}_\{$&vg_val\}.svg
	set plottitle = run\{$runs\}_vgs\{$&vg_val\}
	hardcopy $plotfile0 i(vids) title $plottitle


	* set the iterators
	echo run $&runs
	let vg_val = vg_val + vdelta
	let runs = runs + 1

	* Destroy the transient plot to release memory
	destroy dc1

end

* switch to the const plot
setplot const

echo
echo AWS Iterator = $iterator
echo Total Runs = ($&total_runs + 1)
echo From $&vstart V to $&vmax V
echo From Run $&runs_start to $&runs
echo
.endc
"}
