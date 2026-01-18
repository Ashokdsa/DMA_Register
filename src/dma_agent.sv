class dma_agent extends uvm_agent;
  dma_driver driver;
  dma_sequencer sequencer;
  dma_monitor monitor;

  `uvm_component_utils(dma_agent)

  function new (string name = "dma_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(uvm_phase phase);
    //ACTIVE BY DEFAULT
    driver = dma_driver::type_id::create("driver", this);
    sequencer = dma_sequencer::type_id::create("sequencer", this);
    monitor = dma_monitor::type_id::create("monitor", this);
  endfunction:build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction:connect_phase

endclass:dma_agent
