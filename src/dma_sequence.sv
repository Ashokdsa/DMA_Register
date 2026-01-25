class dma_base_sequence extends uvm_sequence#(dma_sequence_item); //BASE sequence
  `uvm_object_utils(dma_base_sequence)    //Factory Registration
  dma_sequence_item seq;
  dma_reg_block dma_model;
  bit rst = 1'b1;
  bit[31:0] written,read,pread;
  bit[31:0] val[$];

  function new(string name = "dma_base_sequence");
    bit[31:0] i = 1'b1;
    super.new(name);
    repeat(32) 
    begin
      val.push_back(i);
      i = i << 1;
    end
    $display("VAL = %0p",val);
  endfunction:new

  task body();
    `uvm_fatal(get_name,"NOT EXTENDED")
  endtask

  task rst_compare(uvm_reg a,uvm_status_e status);
    bit[31:0] read;
    a.read(status,read,UVM_BACKDOOR);
    if(read == 32'h00000000)
      `uvm_info(a.get_name,"RESET WORKS HERE",UVM_NONE)
    else
      `uvm_warning(a.get_name,"RESET VALUE DIFFERS")
  endtask

  task proper_val(int pos,int sz,ref bit[31:0] read,ref bit[31:0] pread);
    for(int i = 0; i < 32; i++) //ENSURES ONLY THE DATA OF THE FIELD IS SHOWN
    begin:valid_read
      if(i < pos && i >= pos+sz)
      begin
        pread[i] = 1'b0;
        read[i] = 1'b0;
      end
    end:valid_read
  endtask
endclass

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

//INDIVIDUAL
class intr_sequence extends dma_base_sequence;
  `uvm_object_utils(intr_sequence)    //Factory Registration
  bit[4:0] idx;

  function new(string name = "intr_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING INTERRUPT REGISTER------------------------");
    repeat(32) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $display("VAL = %0p",val);
      if(rst)
      begin
        dma_model.intr.reset();
        rst_compare(dma_model.configu,status);
        rst = 0;
      end
      dma_model.intr.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",pread,pread[15:0],pread[31:16]);
      
      written = pread;
      idx = 0;
      while(written == pread)
      begin
        written = val[idx];
        if(idx >= val.size()) idx = 0;
        else idx++;
      end
      if(idx != 0) val.delete(idx-1);
      else val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.intr.write(status,written,UVM_FRONTDOOR);

      dma_model.intr.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",written,read,read[15:0],read[31:16]);

      //CHECK FOR RO FIELD
      if(read[15:0] == pread[15:0])
        `uvm_info("INTR.STATUS","IS A READ ONLY REGISTER FIELD",UVM_LOW)
      else
        `uvm_error("INTR.STATUS","IS NOT READ ONLY REGISTER FIELD")

      //CHECK FOR RW FIELD
      if(read[31:16] == written[31:16])
        `uvm_info("INTR.MASK","IS A READ WRITE REGISTER FIELD",UVM_LOW)
      else
        `uvm_error("INTR.MASK","IS NOT READ WRITE REGISTER FIELD")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",pread,pread[15:0],pread[31:16]);

    $display("POKING 32'hFFFFFFFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.intr.poke(status,32'hFFFFFFFF);
    dma_model.intr.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",32'hFFFFFFFF,read,read[15:0],read[31:16]);
    if(read != 32'hFFFFFFFF)
      `uvm_error("INTR REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass

/*

class ctrl_sequence extends dma_base_sequence;
  `uvm_object_utils(ctrl_sequence)    //Factory Registration

  function new(string name = "ctrl_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    repeat(10) begin
      check_RW(dma_model.ctrl,dma_model.ctrl.start_dma,status,1,0);
      check_RW(dma_model.ctrl,dma_model.ctrl.w_count,status,15,1);
      check_RW(dma_model.ctrl,dma_model.ctrl.io_mem,status,1,16);
      check_RO(dma_model.ctrl,dma_model.ctrl.Reserved,status,15,15);
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
    repeat(10) begin
      check_RW(dma_model.io_addr,dma_model.io_addr.io_addr,status,32,0);
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
    repeat(10) begin
      check_RW(dma_model.mem_addr,dma_model.mem_addr.mem_addr,status,32,0);
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
    repeat(10) begin
      check_RO(dma_model.status,dma_model.status.busy,status,1,0);
      check_RO(dma_model.status,dma_model.status.done,status,1,1);
      check_RO(dma_model.status,dma_model.status.error,status,1,2);
      check_RO(dma_model.status,dma_model.status.paused,status,1,3);
      check_RO(dma_model.status,dma_model.status.current_state,status,4,4);
      check_RO(dma_model.status,dma_model.status.fifo_level,status,8,8);
      check_RO(dma_model.status,dma_model.status.Reserved,status,16,16);
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
    repeat(10) begin
      check_RW(dma_model.extra_info,dma_model.extra_info.extra_info,status,32,0);
    end
  endtask

endclass

class transfer_count_sequence extends dma_base_sequence;
  `uvm_object_utils(transfer_count_sequence)    //Factory Registration

  function new(string name = "transfer_count_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    repeat(10) begin
      check_RO(dma_model.transfer_count,dma_model.transfer_count.transfer_count,status,32,0);
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
    repeat(10) begin
      check_RW(dma_model.descriptor_addr,dma_model.descriptor_addr.descriptor_addr,status,32,0);
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

class config_sequence extends dma_base_sequence;
  `uvm_object_utils(config_sequence)    //Factory Registration

  function new(string name = "config_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;

    repeat(10) begin
      check_RW(dma_model.configu,dma_model.configu.prioriti,status,2,0);
      check_RW(dma_model.configu,dma_model.configu.auto_restart,status,1,2);
      check_RW(dma_model.configu,dma_model.configu.interrupt_enable,status,1,3);
      check_RW(dma_model.configu,dma_model.configu.burst_size,status,2,4);
      check_RW(dma_model.configu,dma_model.configu.data_width,status,2,6);
      check_RW(dma_model.configu,dma_model.configu.descriptor_mode,status,1,8);
      check_RO(dma_model.configu,dma_model.configu.Reserved,status,23,9);
    end
  endtask
endclass
*/
