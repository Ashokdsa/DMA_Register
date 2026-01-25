class reset_all_test extends uvm_test;
  `uvm_component_utils(reset_all_test)    //Factory Registration
  dma_environment dma_env;
  reset_all_sequence base;
  dma_report_server disp;

  function new(string name = "reset_all_test",uvm_component parent = null);
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
    base = reset_all_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:reset_all_test

class intr_test extends uvm_test;
  `uvm_component_utils(intr_test)    //Factory Registration
  dma_environment dma_env;
  intr_sequence base;
  dma_report_server disp;

  function new(string name = "intr_test",uvm_component parent = null);
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
    base = intr_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:intr_test

/*
class ctrl_test extends uvm_test;
  `uvm_component_utils(ctrl_test)    //Factory Registration
  dma_environment dma_env;
  ctrl_sequence base;
  dma_report_server disp;

  function new(string name = "ctrl_test",uvm_component parent = null);
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
    base = ctrl_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:ctrl_test

class io_addr_test extends uvm_test;
  `uvm_component_utils(io_addr_test)    //Factory Registration
  dma_environment dma_env;
  io_addr_sequence base;
  dma_report_server disp;

  function new(string name = "io_addr_test",uvm_component parent = null);
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
    base = io_addr_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:io_addr_test

class mem_addr_test extends uvm_test;
  `uvm_component_utils(mem_addr_test)    //Factory Registration
  dma_environment dma_env;
  mem_addr_sequence base;
  dma_report_server disp;

  function new(string name = "mem_addr_test",uvm_component parent = null);
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
    base = mem_addr_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:mem_addr_test

class extra_info_test extends uvm_test;
  `uvm_component_utils(extra_info_test)    //Factory Registration
  dma_environment dma_env;
  extra_info_sequence base;
  dma_report_server disp;

  function new(string name = "extra_info_test",uvm_component parent = null);
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
    base = extra_info_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:extra_info_test

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

class error_status_test extends uvm_test;
  `uvm_component_utils(error_status_test)    //Factory Registration
  dma_environment dma_env;
  error_status_sequence base;
  dma_report_server disp;

  function new(string name = "error_status_test",uvm_component parent = null);
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
    base = error_status_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:error_status_test

class config_test extends uvm_test;
  `uvm_component_utils(config_test)    //Factory Registration
  dma_environment dma_env;
  config_sequence base;
  dma_report_server disp;

  function new(string name = "config_test",uvm_component parent = null);
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
    base = config_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:config_test

class status_test extends uvm_test;
  `uvm_component_utils(status_test)    //Factory Registration
  dma_environment dma_env;
  status_sequence base;
  dma_report_server disp;

  function new(string name = "status_test",uvm_component parent = null);
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
    base = status_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:status_test

class transfer_count_test extends uvm_test;
  `uvm_component_utils(transfer_count_test)    //Factory Registration
  dma_environment dma_env;
  transfer_count_sequence base;
  dma_report_server disp;

  function new(string name = "transfer_count_test",uvm_component parent = null);
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
    base = transfer_count_sequence::type_id::create("base");    // Create and start the sequence dynamically
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
endclass:transfer_count_test
*/
