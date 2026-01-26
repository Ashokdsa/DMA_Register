QUESTA := /home/share/questa
TEST ?= reset_all_test
V ?= UVM_NONE
SHELL := /bin/bash

.ONESHELL:
all:
	source $(QUESTA)
	make compile
	make simulate
	vcover report -html dma_coverage.ucdb -htmldir covReport -details

clean:
	-rm -rf work/ transcript vsim.wlf wave.vcd vsim_stacktrace.vstf
	-rm -rf covReport dma_coverage.ucdb
	-rm dma.log simulation.log
	-rm dma_coverage.ucdb
	clear
	clear
	clear

compile:
	make clean
	@echo -e "\t\t\t\t...............................COMPILING CODE.............................."
	source $(QUESTA)
	vlog -sv +acc +cover +fcover -l dma.log dma_top.sv 

wave:
	source $(QUESTA)
	make compile
	@echo -e "\t\t\t\t\t...............GENERATING WAVEFORM FOR TEST = $(TEST)..............."
	vsim -novopt work.dma_top +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

simulate:
	source $(QUESTA)
	@echo -e "\t\t\t\t...........................SIMULATING TEST = $(TEST) WITH VERBOSITY = $(V)..........................."
	vsim +define+UVM_REG_NO_INDIVIDUAL_FIELD_ACCESS -vopt work.dma_top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll dma_coverage.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

view:
	firefox ./covReport/index.html
