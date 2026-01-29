class config_sequence extends dma_base_sequence;
  `uvm_object_utils(config_sequence)    //Factory Registration

  function new(string name = "config_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING CONFIGURATION REGISTER------------------------");
    val = val.find() with (item < 32'h00000200);
    repeat(50) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.configu.reset();
        rst_compare(dma_model.configu,status);
        rst = 0;
      end
      dma_model.configu.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | priority(RW|2) = %0h auto_restart(RW|1) = %0h interrupt_enable(RW|1) = %0h burst_size(RW|2) = %0h data_width(RW|2) = %0h descriptor_mode(RW|1) = %0h",pread[8:0],pread[1:0],pread[2],pread[3],pread[5:4],pread[7:6],pread[8]);
      written = pread;
      idx = 0;
      while(written == pread)
      begin
        if(val.size() > 0)
        begin
          written = val[idx];
          if(idx >= val.size()) idx = 0;
          else idx++;
        end
        else
        begin
          dma_model.configu.randomize();
          written = (dma_model.configu.descriptor_mode.value << 8) | (dma_model.configu.data_width.value << 6) | (dma_model.configu.burst_size.value << 4) | (dma_model.configu.interrupt_enable.value << 3) | (dma_model.configu.auto_restart.value << 2) | (dma_model.configu.prioriti.value);
        end
      end
      if(idx != 0) val.delete(idx-1);
      else if(val.size() > 0)val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.configu.write(status,written,UVM_FRONTDOOR);
      dma_model.configu.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | priority(RW|2) = %0h auto_restart(RW|1) = %0h interrupt_enable(RW|1) = %0h burst_size(RW|2) = %0h data_width(RW|2) = %0h descriptor_mode(RW|1) = %0h",written,read[8:0],read[1:0],read[2],read[3],read[5:4],read[7:6],read[8]);

      //CHECK FOR RW FIELDS
      if(read[8:0] == written[8:0])
        `uvm_info("CONFIG REGISTER","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("CONFIG REGISTER","IS NOT READ WRITE REGISTER")

      //CHECKING FOR READ
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | priority(RW|2) = %0h auto_restart(RW|1) = %0h interrupt_enable(RW|1) = %0h burst_size(RW|2) = %0h data_width(RW|2) = %0h descriptor_mode(RW|1) = %0h",read[8:0],read[1:0],read[2],read[3],read[5:4],read[7:6],read[8]);
      $display("POKING 32'h%0h INTO THE REGISTER",written);
      dma_model.configu.poke(status,written);
      dma_model.configu.read(status,read,UVM_FRONTDOOR);
      $display("AFTER READING %0h: FULL = %0h | priority(RW|2) = %0h auto_restart(RW|1) = %0h interrupt_enable(RW|1) = %0h burst_size(RW|2) = %0h data_width(RW|2) = %0h descriptor_mode(RW|1) = %0h",32'h000001FF,read[8:0],read[1:0],read[2],read[3],read[5:4],read[7:6],read[8]);
      if(read != written)
        `uvm_error("CONFIG REGISTER","READ OPERATION DOES NOT WORK HERE")
      else
        `uvm_info("CONFIG REGISTER","READ OPERATION WORKS HERE",UVM_LOW)
    end
  endtask
endclass
