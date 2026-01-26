class status_sequence extends dma_base_sequence;
  `uvm_object_utils(status_sequence)    //Factory Registration

  function new(string name = "status_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING STATUS REGISTER------------------------");
    val = val.find() with (item < 32'h00010000);
    repeat(16) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.status.reset();
        rst_compare(dma_model.status,status);
        rst = 0;
      end
      dma_model.status.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",pread[15:0],pread[0],pread[1],pread[2],pread[3],pread[7:4],pread[15:8]);

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
      dma_model.status.write(status,written,UVM_FRONTDOOR);
      dma_model.status.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",written,pread[15:0],pread[0],pread[1],pread[2],pread[3],pread[7:4],pread[15:8]);

      //CHECK FOR RO FIELD
      if(read[15:0] == pread[15:0])
        `uvm_info("STATUS REGISTER","IS A READ ONLY REGISTER",UVM_LOW)
      else
        `uvm_error("STATUS REGISTER","IS NOT READ ONLY REGISTER")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",written,pread[15:0],pread[0],pread[1],pread[2],pread[3],pread[7:4],pread[15:8]);

    $display("POKING 32'h0000FFFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.status.poke(status,32'h0000FFFF);
    dma_model.status.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",32'h0000FFFF,pread[15:0],pread[0],pread[1],pread[2],pread[3],pread[7:4],pread[15:8]);
    if(read != 32'h0000FFFF)
      `uvm_error("STATUS REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
