QUESTA := /home/share/questa
TEST ?= regression_test
V ?= UVM_NONE
SHELL := /bin/bash
TOP := dma_top
NAME := dma

.ONESHELL:
all:
	source $(QUESTA)
	make compile
	make simulate
	vcover report -html $(NAME)_coverage.ucdb -htmldir covReport -details

clean:
	-rm -rf work/ transcript vsim.wlf wave.vcd vsim_stacktrace.vstf
	-rm -rf covReport $(NAME)_coverage.ucdb
	-rm $(NAME).log simulation.log
	clear
	clear
	clear

compile:
	make clean
	@echo -e "\t\t\t\t...............................COMPILING CODE.............................."
	source $(QUESTA)
	vlog -sv +acc +cover +fcover -l $(NAME).log $(TOP).sv 

wave:
	source $(QUESTA)
	make compile
	@echo -e "\t\t\t\t\t...............GENERATING WAVEFORM FOR TEST = $(TEST)..............."
	vsim -novopt work.$(TOP) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

simulate:
	source $(QUESTA)
	@echo -e "\t\t\t\t...........................SIMULATING TEST = $(TEST) WITH VERBOSITY = $(V)..........................."
	vsim +define+UVM_REG_NO_INDIVIDUAL_FIELD_ACCESS -vopt work.$(TOP) -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll $(NAME)_coverage.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

view:
	firefox ./covReport/index.html
