class error_status_sequence extends dma_base_sequence;
  `uvm_object_utils(error_status_sequence)    //Factory Registration

  function new(string name = "error_status_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    bit[31:0] R1;
    uvm_status_e status;
    $display("------------------------TESTING ERROR STATUS REGISTER------------------------");
    val = val.find() with ((item[5]||item[6]||item[7]) == 1'b0);
    repeat(29) begin
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.error_status.reset();
        rst_compare(dma_model.error_status,status);
        rst = 0;
      end
      dma_model.error_status.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | bus_error(RW1C|1) = %0h timeout_error(RW1C|1) = %0h alignment_error(RW1C|1) = %0h overflow_error(RW1C|1) = %0h underflow_error(RW1C|1) = %0h error_code(RO|8) = %0h error_addr_offset(RO|16) = %0h",pread,pread[0],pread[1],pread[2],pread[3],pread[4],pread[15:8],pread[31:16]);
      
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
      dma_model.error_status.write(status,written,UVM_FRONTDOOR);

      dma_model.error_status.peek(status,read);
      dma_model.error_status.predict(read);
      $display("AFTER WRITING %0h: FULL = %0h | bus_error(RW1C|1) = %0h timeout_error(RW1C|1) = %0h alignment_error(RW1C|1) = %0h overflow_error(RW1C|1) = %0h underflow_error(RW1C|1) = %0h error_code(RO|8) = %0h error_addr_offset(RO|16) = %0h",written,read,read[0],read[1],read[2],read[3],read[4],read[15:8],read[31:16]);

      if(|(written[4:0]) == 1'b1)
      begin
        dma_model.error_status.poke(status,written);
        dma_model.error_status.read(status,R1,UVM_BACKDOOR);
        $display("CHECKING RW1C AFTER POKING %0h: FULL = %0h | bus_error(RW1C|1) = %0h timeout_error(RW1C|1) = %0h alignment_error(RW1C|1) = %0h overflow_error(RW1C|1) = %0h underflow_error(RW1C|1) = %0h error_code(RO|8) = %0h error_addr_offset(RO|16) = %0h",written,R1,R1[0],R1[1],R1[2],R1[3],R1[4],R1[15:8],R1[31:16]);
      end

      //CHECK FOR RO FIELD
      if(read[31:8] == pread[31:8])
        `uvm_info("ERROR_STATUS[31:8]","IS A READ ONLY REGISTER FIELD",UVM_LOW)
      else
        `uvm_error("ERROR_STATUS[31:8]","IS NOT READ ONLY REGISTER FIELD")

      //CHECK FOR RW1C FIELD
      if(written[0]) if(read[0] == 0) `uvm_info("STATUS.bus_error","IS A RW1C REGISTER",UVM_LOW)
                     else `uvm_error("ERROR_STATUS.bus_error","IS NOT A RW1C REGISTER")

      if(written[1]) if(read[1] == 0) `uvm_info("STATUS.timeout_error","IS A RW1C REGISTER",UVM_LOW)
                     else `uvm_error("ERROR_STATUS.timeout_error","IS NOT A RW1C REGISTER")

      if(written[2]) if(read[2] == 0) `uvm_info("STATUS.alignment_error","IS A RW1C REGISTER",UVM_LOW)
                     else `uvm_error("ERROR_STATUS.alignment_error","IS NOT A RW1C REGISTER")

      if(written[3]) if(read[3] == 0) `uvm_info("STATUS.overflow_error","IS A RW1C REGISTER",UVM_LOW)
                     else `uvm_error("ERROR_STATUS.overflow_error","IS NOT A RW1C REGISTER")

      if(written[4]) if(read[4] == 0) `uvm_info("STATUS.underflow_error","IS A RW1C REGISTER",UVM_LOW)
                     else `uvm_error("ERROR_STATUS.underflow_error","IS NOT A RW1C REGISTER")
    end
    //CHECK IF READ WORKS PROPERLY
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | bus_error(RW1C|1) = %0h timeout_error(RW1C|1) = %0h alignment_error(RW1C|1) = %0h overflow_error(RW1C|1) = %0h underflow_error(RW1C|1) = %0h error_code(RO|8) = %0h error_addr_offset(RO|16) = %0h",pread,pread[0],pread[1],pread[2],pread[3],pread[4],pread[15:8],pread[31:16]);
    $display("POKING 32'hFFFFFF1F INTO THE REGISTER");
    dma_model.error_status.poke(status,32'hFFFFFF1F);
    dma_model.error_status.read(status,R1,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: FULL = %0h | bus_error(RW1C|1) = %0h timeout_error(RW1C|1) = %0h alignment_error(RW1C|1) = %0h overflow_error(RW1C|1) = %0h underflow_error(RW1C|1) = %0h error_code(RO|8) = %0h error_addr_offset(RO|16) = %0h",written,R1,R1[0],R1[1],R1[2],R1[3],R1[4],R1[15:8],R1[31:16]);
    if(R1 != 32'hFFFFFF1F)
      `uvm_error("ERROR_STATUS REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
