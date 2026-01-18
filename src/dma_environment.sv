class dma_environment extends uvm_env;
  dma_agent agent;
  dma_subscriber subscriber;
  dma_reg_block dma_model;
  dma_adapter adapter;
  uvm_reg_predictor#(dma_sequence_item) predictor;

  `uvm_component_utils(dma_environment)

  function new(string name = "dma_environment", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    predictor = uvm_reg_predictor#(dma_sequence_item)::type_id::create("predictor", this);
    
    agent = dma_agent::type_id::create("agent", this);  
    
    uvm_config_db#(uvm_active_passive_enum) :: set(this,"agent","is_active",UVM_ACTIVE);
    
    subscriber = dma_subscriber::type_id::create("coverage", this);

    dma_model = dma_reg_block::type_id::create("dma_model", this);  
    dma_model.build();
    
    adapter = dma_adapter::type_id::create("adapter", this);  

  endfunction:build_phase

  function void connect_phase(uvm_phase phase);    								   
    agent.monitor.item_collected_port.connect(subscriber.analysis_export);

    dma_model.set_sequencer(agent.sequencer,adapter);
    dma_model.default_map.set_base_addr(0);

    predictor.map = dma_model.default_map;
    predictor.adapter = adapter;

    agent.monitor.item_collected_port.connect(predictor.bus_in);
    dma_model.default_map.set_auto_predict(0);
  endfunction:connect_phase
endclass:dma_environment
