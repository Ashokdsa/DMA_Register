class error_status_sequence extends dma_base_sequence;
  `uvm_object_utils(error_status_sequence)    //Factory Registration

  function new(string name = "error_status_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;

    repeat(10) begin
      check_RW1C(dma_model.error_status,dma_model.error_status.bus_error,status,0);
      check_RW1C(dma_model.error_status,dma_model.error_status.timeout_error,status,1);
      check_RW1C(dma_model.error_status,dma_model.error_status.alignment_error,status,2);
      check_RW1C(dma_model.error_status,dma_model.error_status.overflow_error,status,3);
      check_RW1C(dma_model.error_status,dma_model.error_status.underflow_error,status,4);
      check_RO(dma_model.error_status,dma_model.error_status.Reserved,status,3,5);
      check_RO(dma_model.error_status,dma_model.error_status.error_code,status,8,8);
      check_RO(dma_model.error_status,dma_model.error_status.error_addr_offset,status,16,16);
    end
  endtask

endclass
