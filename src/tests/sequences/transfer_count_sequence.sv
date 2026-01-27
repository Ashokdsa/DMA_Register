class transfer_count_sequence extends dma_base_sequence;
  `uvm_object_utils(transfer_count_sequence)    //Factory Registration

  function new(string name = "transfer_count_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING TRANSFER_COUNT REGISTER------------------------");
    //RESET IF SEQUENCE IS CALLED ALONE
    if(rst)
    begin
      dma_model.transfer_count.reset();
      rst_compare(dma_model.transfer_count,status);
      rst = 0;
    end
    //FOR PREDICTABLE VALUES
    `uvm_info("TRANSFER_COUNT SEQ","BACKDOOR WRITING 0 TO CTRL REG AND THEN POKING 0 TO STATUS AND TRANSFER_COUNT",UVM_HIGH)
    dma_model.ctrl.write(status,32'h00000000,UVM_BACKDOOR);
    dma_model.status.poke(status,32'h00000000);
    dma_model.transfer_count.poke(status,32'h00000000);
    repeat(32) begin
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      dma_model.transfer_count.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: transfer_count(RO|32) = %0h",pread);
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
      dma_model.transfer_count.write(status,written,UVM_FRONTDOOR);
      dma_model.transfer_count.peek(status,read);
      $display("AFTER WRITING %0h: transfer_count(RO|32) = %0h",written,read);

      //CHECK FOR RO FIELD
      if(read == pread)
        `uvm_info("TRANSFER_COUNT","IS A READ ONLY REGISTER",UVM_LOW)
      else
        `uvm_error("TRANSFER_COUNT","IS NOT READ ONLY REGISTER")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: transfer_count(RO|32) = %0h",pread);

    $display("POKING 32'hFFFFFFFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.transfer_count.poke(status,32'hFFFFFFFF);
    dma_model.transfer_count.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: transfer_count(RO|32) = %0h",32'hFFFFFFFF,read);
    if(read != 32'hFFFFFFFF)
      `uvm_error("TRANSFER_COUNT REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
