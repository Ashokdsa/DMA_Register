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
    repeat(17) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.ctrl.reset();
        rst_compare(dma_model.ctrl,status);
        rst = 0;
      end
      dma_model.ctrl.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",pread[16:0],pread[0],pread[15:1],pread[16]);
      
      written = pread;
      idx = 0;
      while(written == pread)
      begin
        written = val[idx];
        if(idx >= val.size()) idx = 0;
        else idx++;
      end
      if(idx > 0) val.delete(idx-1);
      else val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.ctrl.write(status,written,UVM_FRONTDOOR);

      dma_model.ctrl.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",written,read[16:0],read[0],read[15:1],read[16]);

      //CHECK FOR RW FIELD
      if(read[16:0] == written[16:0])
        `uvm_info("CTRL REGISTER","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("CTRL REGISTER","IS NOT READ WRITE REGISTER")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",pread[16:0],pread[0],pread[15:1],pread[16]);

    $display("POKING 32'h00001FFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.ctrl.poke(status,32'h1FFFF);
    dma_model.ctrl.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: FULL = %0h | start_dma(RW|1) = %0h w_count(RW|15) = %0h io_mem(RW|1) = %0h",32'h1FFFF,read[16:0],read[0],read[15:1],read[16]);
    if(read != 32'h0001FFFF)
      `uvm_error("CTRL REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
