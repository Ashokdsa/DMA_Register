class dma_base_sequence extends uvm_sequence#(dma_sequence_item); //BASE sequence
  `uvm_object_utils(dma_base_sequence)    //Factory Registration
  dma_sequence_item seq;
  dma_block dma_model;
  bit[31:0] written_addr,read;

  function new(string name = "dma_base_sequence");
    super.new(name);
  endfunction:new

  task body();
    `uvm_fatal(get_name,"NOT EXTENDED")
  endtask

  task rst_compare(uvm a);
    a.read(status,read,UVM_BACKDOOR);
    read = a.get_mirrored_value();
    if(read == 31'h00000000)
      `uvm_info(a.get_name,"RESET WORKS HERE",UVM_NONE)
  endtask

  task write_and_mirror_field(uvm_field_reg regi, bit[31:0] val,output uvm__regstatus_e status);
    regi.write(status,val);
    regi.mirror(status,UVM_CHECK,UVM_BACKDOOR);
  endtask

  task write_and_mirror(uvm_reg regi, bit[31:0] val,output uvm_regstatus_e status);
    regi.write(status,val);
    regi.mirror(status,UVM_CHECK,UVM_BACKDOOR);
  endtask
endclass

class all_reset_sequence extends dma_base_sequence;
  `uvm_object_utils(all_reset_sequence)    //Factory Registration

  function new(string name = "all_reset_sequence");
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
    while(1)
    begin
      if(written >= 32'h8000)
        break;
      write_and_mirror_field(dma_model.intr.intr_mask,written,status);
      if(written == 0)
        written = 1;
      else written = written << 1;
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
    while(1)
    begin
      write_and_mirror(dma_model.ctrl,written,status);
      written[0] = ~written[0];
      written[16] = ~written[16];
      if(written[15:1] == 0)
        written[15:1] = 15'd1;
      else if(written[15:1] == 16'h4000)
        break;
      else
        written[15:1] = written[15:1] << 1;
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
    while(1)
    begin
      write_and_mirror(dma_model.io_addr,written,status);
      if(written == 0)
        written = 15'd1;
      else if(written == 32'h80000000)
        break;
      else
        written = written << 1;
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
    while(1)
    begin
      write_and_mirror(dma_model.mem_addr,written,status);
      if(written == 0)
        written = 15'd1;
      else if(written == 32'h80000000)
        break;
      else
        written = written << 1;
    end
  endtask

endclass

//NOT DEFINED
class status_sequence extends dma_base_sequence;
  `uvm_object_utils(status_sequence)    //Factory Registration

  function new(string name = "status_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
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
    while(1)
    begin
      write_and_mirror(dma_model.extra_info,written,status);
      if(written == 0)
        written = 15'd1;
      else if(written == 32'h80000000)
        break;
      else
        written = written << 1;
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
    while(1)
    begin
      write_and_mirror(dma_model.descriptor_addr,written,status);
      if(written == 0)
        written = 15'd1;
      else if(written == 32'h80000000)
        break;
      else
        written = written << 1;
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

    while(written < 8'h20)
    begin
      write_and_mirror(dma_model.error_status,written,status);
      written++;
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

    while(written < 12'h200)
    begin
      write_and_mirror(dma_model.config,written,status);
      written++;
    end
  endtask

endclass

//CONTINUE
class normal_sequence extends dma_base_sequence;
  `uvm_object_utils(normal_sequence)    //Factory Registration

  function new(string name = "normal_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
    //PROGRAM IO,MEM,CTRL,CONFIG
    //START_DMA
    write_and_mirror_field(dma_model.ctrl.start_dma,1,status);

    //DMA ACTIVE
    dma_model.status.busy.predict(1);
    dma_model.status.busy.read(status,read,UVM_BACKDOOR);
    if(read[0] == 1)
      `uvm_info(get_name,"DMA IS BUSY",UVM_NONE)
    else
      `uvm_error(get_name,"DMA IS SHOWN AS NOT BUSY WHEN ACTIVE")


    //MULTIPLE TRANSFERS increment transfer_count

    //COMPLETION
    dma_model.done.busy.predict(1);
    dma_model.done.busy.read(status,read,UVM_BACKDOOR);
    if(read[0] == 1)
      `uvm_info(get_name,"DONE IS ASSERTED",UVM_NONE)
    else
      `uvm_error(get_name,"DONE IS NOT ASSERTED")

    dma_model.intr.intr_status.predict(0);
    dma_model.intr.intr_status.read(status,read,UVM_BACKDOOR)
    if(read[0] == 1)
      `uvm_info(get_name,"TRANSFER COMPLETED",UVM_NONE)
    else
      `uvm_error(get_name,"TRANSFER ISN'T COMPLETED")

    dma_model.status.read(status,read,UVM_BACKDOOR);
    if(read[2])
    begin
      `uvm_info(get_name,"ERROR DETECTED",UVM_NONE)
      $display("------------------------------------TYPE OF ERRORS:------------------------------------\n");
      dma_model.error_status.read(status,read,UVM_BACKDOOR);
      if(read[0])
        $display("BUS ERROR");
      if(read[1])
        $display("TIMEOUT ERROR");
      if(read[2])
        $display("ALIGNMENT ERROR");
      if(read[3])
        $display("OVERFLOW ERROR");
      if(read[4])
        $display("UNDERFLOW ERROR");
    end

  endtask

endclass

//YET TO
class randomize_RW_sequence extends dma_base_sequence;
  `uvm_object_utils(randomize_RW_sequence)    //Factory Registration

  function new(string name = "randomize_RW_sequence");
    super.new(name);
  endfunction:new

  task body();
    uvm_status_e status;
    dma_model.reset();
  endtask

endclass

