class ctrl_sequence extends dma_base_sequence;
  `uvm_object_utils(ctrl_sequence)    //Factory Registration

  function new(string name = "ctrl_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING CONTROL REGISTER------------------------");
    val = val.find() with (item < 32'h00020000);
    if(rst)
    begin
      dma_model.ctrl.reset();
      rst_compare(dma_model.ctrl,status);
      rst = 0;
    end
    repeat(50) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      dma_model.ctrl.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",pread[16:0],pread[0],pread[15:1],pread[16]);
      
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
        else begin
          //RANDOM INPUTS
          dma_model.ctrl.randomize();
          written = (dma_model.ctrl.start_dma.value) | (dma_model.ctrl.w_count.value << 1) | (dma_model.ctrl.io_mem.value << 16); 
        end
      end
      if(idx > 0) val.delete(idx-1);
      else if(val.size() > 0) val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.ctrl.write(status,written,UVM_FRONTDOOR);

      dma_model.ctrl.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",written,read[16:0],read[0],read[15:1],read[16]);

      //CHECK FOR RW FIELD
      if(read[16:0] == written[16:0])
        `uvm_info("CTRL REGISTER","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("CTRL REGISTER","IS NOT READ WRITE REGISTER")

      //CHECKING FOR FRONTDOOR READ
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",read[16:0],read[0],read[15:1],read[16]);
      $display("POKING 32'h%0h INTO THE REGISTER",written);

      dma_model.ctrl.poke(status,written);
      dma_model.ctrl.read(status,read,UVM_FRONTDOOR);

      $display("AFTER READING %0h(LAST BIT BECOMES 0 AFTER WRITING 1): FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",written,read[16:0],read[0],read[15:1],read[16]);
      if((read[16:1] != written[16:1]) && (read[0] == 0)) //As the READ takes 3 cycles by then start_dma gets reset
        `uvm_error("CTRL REGISTER","READ OPERATION DOES NOT WORK HERE")
      else
        `uvm_info("CTRL REGISTER","READ OPERATION WORKS HERE",UVM_LOW)
    end
  endtask
endclass
