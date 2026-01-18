class dma_base_sequence extends uvm_sequence#(dma_sequence_item); //BASE sequence
  `uvm_object_utils(dma_base_sequence)    //Factory Registration
  dma_sequence_item seq;
  dma_reg_block dma_model;
  bit[31:0] written,read;

  function new(string name = "dma_base_sequence");
    super.new(name);
  endfunction:new

  task body();
    `uvm_fatal(get_name,"NOT EXTENDED")
  endtask

  task rst_compare(uvm_reg a);
    a.read(status,read,UVM_BACKDOOR);
    read = a.get_mirrored_value();
    if(read == 31'h00000000)
      `uvm_info(a.get_name,"RESET WORKS HERE",UVM_NONE)
  endtask
endclass

class all_reset_sequence extends dma_base_sequence;
  `uvm_object_utils(master_new_sequence)    //Factory Registration

  function new(string name = "all_reset_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    rst_compare(dma_model.intr);
    rst_compare(dma_model.ctrl);
    rst_compare(dma_model.io_addr);
    rst_compare(dma_model.mem_addr);
    rst_compare(dma_model.extra_info);
    rst_compare(dma_model.status);
    rst_compare(dma_model.transfer_count);
    rst_compare(dma_model.descriptor_addr);
    rst_compare(dma_model.error_status);
    rst_compare(dma_model.configu);
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
  endtask
endclass
