class dma_reg_block extends uvm_reg_block;
  `uvm_object_utils(dma_reg_block)
  intr_reg
  ctrl_reg
  io_addr_reg
  mem_addr_reg
  extra_info_reg
  status_reg
  transfer_count_reg
  descriptor_addr_reg
  error_status_reg
  config_reg


  function new(string name = "dma_reg_block");
    super.new(name,build_coverage(UVM_NO_COVERAGE));
  endfunction
endclass
