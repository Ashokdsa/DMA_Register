class reset_all_test extends uvm_test;
  `uvm_component_utils(reset_all_test)    //Factory Registration
  dma_environment dma_env;
  reset_all_sequence base;

  function new(string name = "reset_all_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dma_env = dma_environment::type_id::create("dma_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    base = reset_all_sequence::type_id::create("base");    // Create and start the sequence dynamically
    super.run_phase(phase);
    phase.raise_objection(this);    //Raise Objection
      base.dma_model = dma_env.dma_model;
      `uvm_info(get_name,"SEQUENCE STARTED",UVM_NONE)
      base.start(dma_env.agent.sequencer);
    phase.drop_objection(this);    //Drop Objection
    phase_done.set_drain_time(this,20);    // Drain time before dropping objection
    `uvm_info(get_name,"SEQUENCE ENDED",UVM_NONE)
    $display("--------------------------------------------------TEST ENDED--------------------------------------------------");
  endtask:run_phase
endclass:reset_all_test
