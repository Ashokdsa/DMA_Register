class regression_sequence extends dma_base_sequence;
  `uvm_object_utils(regression_sequence)    //Factory Registration
  config_sequence                 config_seq;
  ctrl_sequence                   ctrl_seq;
  descriptor_addr_sequence        descriptor_addr_seq; 
  error_status_sequence           error_status_seq; 
  extra_info_sequence             extra_info_seq; 
  intr_sequence                   intr_seq;
  io_addr_sequence                io_addr_seq;
  mem_addr_sequence               mem_addr_seq;
  reset_all_sequence              reset_all_seq;
  status_sequence                 status_seq;
  transfer_count_sequence         transfer_count_seq;
  function new(string name = "regression_sequence");
    super.new(name);
    rst = 0;
    reset_all_seq       = reset_all_sequence::type_id::create("reset_all_sequence");
    intr_seq            = intr_sequence::type_id::create("intr_sequence");
    ctrl_seq            = ctrl_sequence::type_id::create("ctrl_sequence");
    io_addr_seq         = io_addr_sequence::type_id::create("io_addr_sequence");
    mem_addr_seq        = mem_addr_sequence::type_id::create("mem_addr_sequence");
    extra_info_seq      = extra_info_sequence::type_id::create("extra_info_sequence");
    status_seq          = status_sequence::type_id::create("status_sequence");
    transfer_count_seq  = transfer_count_sequence::type_id::create("transfer_count_sequence");
    descriptor_addr_seq = descriptor_addr_sequence::type_id::create("descriptor_addr_sequence");
    error_status_seq    = error_status_sequence::type_id::create("error_status_sequence");
    config_seq          = config_sequence::type_id::create("config_sequence");
  endfunction:new

  task pre_body();
    reset_all_seq.dma_model = dma_model; 
    intr_seq.dma_model = dma_model; 
    ctrl_seq.dma_model = dma_model; 
    io_addr_seq.dma_model = dma_model; 
    mem_addr_seq.dma_model = dma_model; 
    extra_info_seq.dma_model = dma_model; 
    status_seq.dma_model = dma_model; 
    transfer_count_seq.dma_model = dma_model; 
    descriptor_addr_seq.dma_model = dma_model;
    error_status_seq.dma_model = dma_model; 
    config_seq.dma_model = dma_model; 

    intr_seq.rst = 0; 
    ctrl_seq.rst = 0; 
    io_addr_seq.rst = 0; 
    mem_addr_seq.rst = 0; 
    extra_info_seq.rst = 0; 
    status_seq.rst = 0; 
    transfer_count_seq.rst = 0; 
    descriptor_addr_seq.rst = 0;
    error_status_seq.rst = 0; 
    config_seq.rst = 0; 
  endtask

  task body();
    $display("------------------------REGRESSION-TESTING------------------------");
    reset_all_seq.start(m_sequencer);
    status_seq.start(m_sequencer);
    transfer_count_seq.start(m_sequencer);
    intr_seq.start(m_sequencer);
    ctrl_seq.start(m_sequencer);
    io_addr_seq.start(m_sequencer);
    mem_addr_seq.start(m_sequencer);
    extra_info_seq.start(m_sequencer);
    descriptor_addr_seq.start(m_sequencer);
    error_status_seq.start(m_sequencer);
    config_seq.start(m_sequencer);
  endtask
endclass
