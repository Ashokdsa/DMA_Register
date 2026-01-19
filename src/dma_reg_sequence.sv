class dma_base_sequence extends uvm_sequence#(dma_sequence_item); //BASE sequence
  `uvm_object_utils(dma_base_sequence)    //Factory Registration
  dma_sequence_item seq;
  dma_reg_block dma_model;
  bit[31:0] written_addr,read;

  function new(string name = "dma_base_sequence");
    super.new(name);
  endfunction:new

  task body();
    `uvm_fatal(get_name,"NOT EXTENDED")
  endtask

  task rst_compare(uvm_reg a);
    a.read(status,read,UVM_BACKDOOR);
    if(read == 32'h00000000)
      `uvm_info(a.get_name,"RESET WORKS HERE",UVM_NONE)
    else
      `uvm_warning(a.get_name,"RESET VALUE DIFFERS")

  endtask

  task check_RO(uvm_reg_field regi, uvm_reg_status_e status,int sz);
    bit[sz-1:0] written,read,pread;
    regi.read(status,pread,UVM_BACKDOOR);
    written = pread;
    while(written == pread)
      written = $urandom();
    regi.write(status,written);
    regi.mirror(status,read,UVM_BACKDOOR);
    if(read === pread)
      `uvm_info(regi.get_full_name,"IS A READ ONLY FIELD",UVM_NONE)
    else
      `uvm_error(regi.get_full_name,"IS NOT A READ ONLY FIELD")
  endtask

  task check_RW(uvm_reg_field regi, output uvm_reg_status_e status,int sz);
    bit[sz-1:0] written,read,pread;
    regi.read(status,pread,UVM_BACKDOOR);
    written = pread;
    while(written == pread)
      written = $urandom();
    regi.write(status,written);
    regi.mirror(status,read,UVM_BACKDOOR);
    if(read === written)
      `uvm_info(regi.get_full_name,"IS A RW FIELD",UVM_NONE)
    else
      `uvm_error(regi.get_full_name,"IS NOT A RW FIELD")
  endtask

  task check_RW1C(uvm_reg_field regi, output uvm_reg_status_e status);
    bit written,read,pread;
    regi.read(status,pread,UVM_BACKDOOR);
    written = pread;
    while(written == pread)
      written = $urandom();
    regi.write(status,written);
    regi.mirror(status,read,UVM_BACKDOOR);
    if(written && !read)
      `uvm_info(regi.get_full_name,"IS A RW1C FIELD",UVM_NONE)
    else if(written && read)
      `uvm_error(regi.get_full_name,"IS NOT A RW1C FIELD")
  endtask
endclass

class reset_all_sequence extends dma_base_sequence;
  `uvm_object_utils(reset_all_sequence)    //Factory Registration

  function new(string name = "reset_all_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_reg_status_e status;
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
  endtask
endclass

//INDIVIDUAL
class intr_sequence extends dma_base_sequence;
  `uvm_object_utils(intr_sequence)    //Factory Registration

  function new(string name = "intr_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RO(dma_model.intr.intr_status,status,16);
      check_RW(dma_model.intr.intr_mask,status,16);
    end
  endtask

endclass

class ctrl_sequence extends dma_base_sequence;
  `uvm_object_utils(ctrl_sequence)    //Factory Registration

  function new(string name = "ctrl_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RW(dma_model.ctrl.start_dma,status,1);
      check_RW(dma_model.ctrl.w_count,status,15);
      check_RW(dma_model.ctrl.io_mem,status,1);
      check_RO(dma_model.ctrl.Reserved,status,15);
    end
  endtask

endclass

class io_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(io_addr_sequence)    //Factory Registration

  function new(string name = "io_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RW(dma_model.io_addr.io_addr,status,32);
    end
  endtask

endclass

class mem_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(mem_addr_sequence)    //Factory Registration

  function new(string name = "mem_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RW(dma_model.mem_addr.mem_addr,status,32);
    end
  endtask

endclass

class status_sequence extends dma_base_sequence;
  `uvm_object_utils(status_sequence)    //Factory Registration

  function new(string name = "status_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RO(dma_model.status.busy,status,1);
      check_RO(dma_model.status.done,status,1);
      check_RO(dma_model.status.error,status,1);
      check_RO(dma_model.status.paused,status,1);
      check_RO(dma_model.status.current_state,status,4);
      check_RO(dma_model.status.fifo_level,status,8);
      check_RO(dma_model.status.Reserved,status,16);
    end
  endtask

endclass

class extra_info_sequence extends dma_base_sequence;
  `uvm_object_utils(extra_info_sequence)    //Factory Registration

  function new(string name = "extra_info_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RW(dma_model.extra_info.extra_info,status,32);
    end
  endtask

endclass

//NOT DECIDED
class transfer_count_sequence extends dma_base_sequence;
  `uvm_object_utils(transfer_count_sequence)    //Factory Registration

  function new(string name = "transfer_count_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RO(dma_model.transfer_count.transfer_count,status,32);
    end
  endtask

endclass

class descriptor_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(descriptor_addr_sequence)    //Factory Registration

  function new(string name = "descriptor_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    repeat(10) begin
      check_RW(dma_model.descriptor_addr.descriptor_addr,status,32);
    end
  endtask

endclass

class error_status_sequence extends dma_base_sequence;
  `uvm_object_utils(error_status_sequence)    //Factory Registration

  function new(string name = "error_status_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();

    repeat(10) begin
      check_RW1C(dma_model.error_status.bus_error,status);
      check_RW1C(dma_model.error_status.timeout_error,status);
      check_RW1C(dma_model.error_status.alignment_error,status);
      check_RW1C(dma_model.error_status.overflow_error,status);
      check_RW1C(dma_model.error_status.underflow_error,status);
      check_RO(dma_model.error_status.Reserved,status,3);
      check_RO(dma_model.error_status.error_code,status,8);
      check_RO(dma_model.error_status.error_addr_offset,status,16);
    end
  endtask

endclass

class config_sequence extends dma_base_sequence;
  `uvm_object_utils(config_sequence)    //Factory Registration

  function new(string name = "config_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();

    repeat(10) begin
      check_RW(dma_model.configu.prioriti,status,2);
      check_RW(dma_model.configu.auto_restart,status,1);
      check_RW(dma_model.configu.interrupt_enable,status,1);
      check_RW(dma_model.configu.burst_size,status,2);
      check_RW(dma_model.configu.data_width,status,2);
      check_RW(dma_model.configu.descriptor_mode,status,1);
      check_RO(dma_model.configu.Reserved,status,23);
    end
  endtask
endclass
