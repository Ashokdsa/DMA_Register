class reset_all_sequence extends dma_base_sequence;
  `uvm_object_utils(reset_all_sequence)    //Factory Registration

  function new(string name = "reset_all_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    // OR
    /*
    dma_model.intr.reset(); 
    dma_model.ctrl.reset(); 
    dma_model.io_addr.reset(); 
    dma_model.mem_addr.reset(); 
    dma_model.extra_info.reset(); 
    dma_model.status.reset(); 
    dma_model.transfer_count.reset(); 
    dma_model.descriptor_addr.reset(); 
    dma_model.error_status.reset(); 
    dma_model.configu.reset(); 
    */
    rst_compare(dma_model.intr,status);
    rst_compare(dma_model.ctrl,status);
    rst_compare(dma_model.io_addr,status);
    rst_compare(dma_model.mem_addr,status);
    rst_compare(dma_model.extra_info,status);
    rst_compare(dma_model.status,status);
    rst_compare(dma_model.transfer_count,status);
    rst_compare(dma_model.descriptor_addr,status);
    rst_compare(dma_model.error_status,status);
    rst_compare(dma_model.configu,status);
  endtask
endclass
