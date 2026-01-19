class dma_reg_block extends uvm_reg_block;
  `uvm_object_utils(dma_reg_block)
  rand intr_reg intr;
  rand ctrl_reg ctrl;
  rand io_addr_reg io_addr;
  rand mem_addr_reg mem_addr;
  rand extra_info_reg extra_info;
  rand status_reg status;
  rand transfer_count_reg transfer_count;
  rand descriptor_addr_reg descriptor_addr;
  rand error_status_reg error_status;
  rand config_reg configu;

  function new(string name = "dma_reg_block");
    super.new(name,build_coverage(UVM_NO_COVERAGE));
  endfunction

  function void build();
    add_hdl_path ("dut", "RTL");
    uvm_reg::include_coverage("*", UVM_CVR_ALL);

    intr = intr_reg::type_id::create("intr");
    ctrl = ctrl_reg::type_id::create("ctrl");
    io_addr = io_addr_reg::type_id::create("io_addr");
    mem_addr = mem_addr_reg::type_id::create("mem_addr");
    extra_info = extra_info_reg::type_id::create("extra_info");
    status = status_reg::type_id::create("status");
    transfer_count = transfer_count_reg::type_id::create("transfer_count");
    descriptor_addr = descriptor_addr_reg::type_id::create("descriptor_addr");
    error_status = error_status_reg::type_id::create("error_status");
    configu = config_reg::type_id::create("configu");

    intr.build(); 
    ctrl.build();  
    io_addr.build(); 
    mem_addr.build(); 
    extra_info.build(); 
    status.build(); 
    transfer_count.build(); 
    descriptor_addr.build(); 
    error_status.build(); 
    configu.build(); 

    intr.configure(this); 
    ctrl.configure(this);  
    io_addr.configure(this); 
    mem_addr.configure(this); 
    extra_info.configure(this); 
    status.configure(this); 
    transfer_count.configure(this); 
    descriptor_addr.configure(this); 
    error_status.configure(this); 
    configu.configure(this); 

    intr.set_coverage(UVM_CVR_FIELD_VALS); 
    ctrl.set_coverage(UVM_CVR_FIELD_VALS);  
    io_addr.set_coverage(UVM_CVR_FIELD_VALS); 
    mem_addr.set_coverage(UVM_CVR_FIELD_VALS); 
    extra_info.set_coverage(UVM_CVR_FIELD_VALS); 
    status.set_coverage(UVM_CVR_FIELD_VALS); 
    transfer_count.set_coverage(UVM_NO_COVERAGE); 
    descriptor_addr.set_coverage(UVM_CVR_FIELD_VALS); 
    error_status.set_coverage(UVM_CVR_FIELD_VALS); 
    configu.set_coverage(UVM_CVR_FIELD_VALS); 

    intr.add_hdl_path_slice("intr",400, 32);
    ctrl.add_hdl_path_slice("ctrl",404, 32);
    io_addr.add_hdl_path_slice("io_addr",408, 32);
    mem_addr.add_hdl_path_slice("mem_addr",40C, 32);
    extra_info.add_hdl_path_slice("extra_info",410, 32);
    status.add_hdl_path_slice("status",414, 32);
    transfer_count.add_hdl_path_slice("transfer_count",418, 32);
    descriptor_addr.add_hdl_path_slice("descriptor_addr",41C, 32);
    error_status.add_hdl_path_slice("error_status",420, 32);
    configu.add_hdl_path_slice("configu",424, 32);

    default_map = create_map("default_map", 'h400, 4, UVM_LITTLE_ENDIAN);

    default_map.add_reg(intr, 'h0, "RW"); 
    default_map.add_reg(ctrl, 'h4, "RW");  
    default_map.add_reg(io_addr, 'h8, "RW"); 
    default_map.add_reg(mem_addr, 'hC, "RW"); 
    default_map.add_reg(extra_info, 'h10, "RW"); 
    default_map.add_reg(status, 'h14, "RO"); 
    default_map.add_reg(transfer_count, 'h18, "RO"); 
    default_map.add_reg(descriptor_addr, 'h1C, "RW"); 
    default_map.add_reg(error_status, 'h20, "W1C"); 
    default_map.add_reg(configu, 'h24, "RW"); 

    default_map.set_auto_predict(0);

    lock_model();
  endfunction
endclass
