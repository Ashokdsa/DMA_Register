class descriptor_addr_test extends uvm_test;
  `uvm_component_utils(descriptor_addr_test)    //Factory Registration
  dma_environment dma_env;
  descriptor_addr_sequence base;
  dma_report_server disp;

  function new(string name = "descriptor_addr_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    disp = new();
    uvm_report_server::set_server(disp);
    dma_env = dma_environment::type_id::create("dma_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    base = descriptor_addr_sequence::type_id::create("base");    // Create and start the sequence dynamically
    super.run_phase(phase);
    phase.raise_objection(this);    //Raise Objection
      base.dma_model = dma_env.dma_model;
      `uvm_info(get_type_name,$sformatf("%s SEQUENCE STARTED",base.get_type_name),UVM_NONE)
      base.start(dma_env.agent.sequencer);
    phase.drop_objection(this);    //Drop Objection
    phase_done.set_drain_time(this,20);    // Drain time before dropping objection
    `uvm_info(base.get_type_name,$sformatf("%s SEQUENCE ENDED",base.get_type_name),UVM_NONE)
    $display("--------------------------------------------------%0s ENDED--------------------------------------------------",get_type_name);
  endtask:run_phase
endclass:descriptor_addr_test

