class dma_subscriber extends uvm_subscriber#(dma_sequence_item);
  `uvm_component_utils(dma_subscriber)    // Factory registration
  uvm_analysis_imp_passive_mon#(dma_sequence_item,dma_subscriber) pass_mon;      // Analysis implementation to connect passive monitor
  dma_sequence_item inp,out; //sequence items used to sample the covergroup
  
  covergroup cg();
  endgroup:input_cg
  
  function new(string name = "subs", uvm_component parent = null);
    super.new(name,parent);
    cg = new();
  endfunction:new

  virtual function void write(dma_sequence_item t);
    dma_sequence_item seq;
    seq = t;
    cg.sample();
    `uvm_info(get_name,"[MONITOR]:INPUT RECIEVED",UVM_DEBUG)
  endfunction:write

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name,$sformatf("COVERAGE = %0f\n",cg.get_coverage()),UVM_NONE);
  endfunction:report_phase

endclass:dma_subscriber
