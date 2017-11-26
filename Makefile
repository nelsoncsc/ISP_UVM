ifeq ("$(UVMC_HOME)","")
$(error ERROR: UVMC_HOME environment variable is not defined)
endif

# definitions needed for OpenCV:
CV_COPTS=`pkg-config --cflags opencv`
CV_LOPTS=`pkg-config --libs opencv`

# definitions only needed for VCS:
VCS_UVMC_SC_OPTS=-tlm2 -cflags "-g -I. -I$(VCS_HOME)/etc/systemc/tlm/include/tlm/tlm_utils -I$(UVMC_HOME)/src/connect/sc" $(UVMC_HOME)/src/connect/sc/uvmc.cpp $(UVM_HOME)/src/dpi/uvm_dpi.cc


VCS_UVMC_SV_OPTS=-q -sverilog -ntb_opts uvm -timescale=1ns/1ps +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR +incdir+$(UVM_HOME)/src+$(UVM_HOME)/src/vcs+$(UVMC_HOME)/src/connect/sv +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR $(UVM_HOME)/src/uvm_pkg.sv $(UVM_HOME)/src/vcs/*.sv $(UVMC_HOME)/src/connect/sv/uvmc_pkg.sv

VCS_UVMC_OPTS=-q -sysc=deltasync -lca -sysc -debug_pp -timescale=1ns/1ps uvm_custom_install_recording sc_main $(TOP) 

VCS_SIMV= +UVM_NO_RELNOTES +UVM_TR_RECORD +UVM_TESTNAME=$(TEST)

# definitions for files
TOP = top
REFMOD = external/refmod
TEST= simple_test
vcs:	clean
	g++ -c $(CV_COPTS) external/call_opencv.cpp
	g++ -c $(CV_COPTS) external/cvFunction.cpp
	syscan $(VCS_UVMC_SC_OPTS) $(REFMOD).cpp
	vlogan $(VCS_UVMC_SV_OPTS) $(TOP).sv
	vcs    $(VCS_UVMC_OPTS) $(CV_LOPTS) $(TOP) $(CV_LOPTS) cvFunction.o call_opencv.o
	./simv $(VCS_SIMV) +UVM_VERBOSITY=MEDIUM

vcs_debug:clean
	g++ -c $(CV_COPTS) external/call_opencv.cpp
	g++ -c $(CV_COPTS) external/cvFunction.cpp
	syscan $(VCS_UVMC_SC_OPTS) $(REFMOD).cpp
	vlogan $(VCS_UVMC_SV_OPTS) $(TOP).sv
	vcs    $(VCS_UVMC_OPTS) $(CV_LOPTS) $(TOP) $(CV_LOPTS) cvFunction.o call_opencv.o
	./simv $(VCS_SIMV) +UVM_VERBOSITY=HIGH

# if Using Octave
vcs_oct:
	syscan $(VCS_UVMC_SC_OPTS) -cflags "$(OCT_COPTS) -DREFMOD_OCTAVE" $(REFMOD).cpp
	vlogan -q $(VCS_UVMC_SV_OPTS) $(TOP).sv
	vcs -q $(VCS_UVMC_OPTS) $(CV_LOPTS) $(TOP)
	./simv +UVM_VERBOSITY=LOW

vcs_oct_debug:
	syscan $(VCS_UVMC_SC_OPTS) -cflags "$(OCT_COPTS) -DREFMOD_OCTAVE" $(REFMOD).cpp
	vlogan $(VCS_UVMC_SV_OPTS) $(TOP).sv
	vcs -q $(VCS_UVMC_OPTS) $(CV_LOPTS) $(TOP)
	./simv +UVM_VERBOSITY=MEDIUM

clean:
	rm -rf a.out # simulation output file
	rm -rf INCA_libs irun.log ncsc.log # ius
	rm -rf work certe_dump.xml transcript .mgc_simple_ref .mgc_ref_nobuff .mgc_ref_oct # mgc
	rm -rf csrc simv simv.daidir ucli.key .vlogansetup.args .vlogansetup.env .vcs_lib_lock simv.vdb AN.DB vc_hdrs.h *.diag *.vpd *tar.gz # vcs

# Wave form
view_waves:
	dve -vpd vcdplus.vpd &

