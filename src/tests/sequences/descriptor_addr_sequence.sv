class descriptor_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(descriptor_addr_sequence)    //Factory Registration

  function new(string name = "descriptor_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING DESCRIPTOR_ADDR REGISTER------------------------");
    repeat(32) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.descriptor_addr.reset();
        rst_compare(dma_model.descriptor_addr,status);
        rst = 0;
      end
      dma_model.descriptor_addr.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: descriptor_addr(RW|32) = %0h",pread);
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
      dma_model.descriptor_addr.write(status,written,UVM_FRONTDOOR);
      dma_model.descriptor_addr.peek(status,read);
      $display("AFTER WRITING %0h: descriptor_addr(RW|32) = %0h",written,pread);

      //CHECK FOR RW FIELD
      if(read == written)
        `uvm_info("DESCRIPTOR_ADDR","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("DESCRIPTOR_ADDR","IS NOT READ WRITE REGISTER")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: descriptor_addr(RW|32) = %0h",pread);

    $display("POKING 32'hFFFFFFFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.descriptor_addr.poke(status,32'hFFFFFFFF);
    dma_model.descriptor_addr.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: descriptor_addr(RW|32) = %0h",32'hFFFFFFFF,read);
    if(read != 32'hFFFFFFFF)
      `uvm_error("DESCRIPTOR_ADDR REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
