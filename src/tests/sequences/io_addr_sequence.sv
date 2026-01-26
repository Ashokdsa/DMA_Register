class io_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(io_addr_sequence)    //Factory Registration

  function new(string name = "io_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING IO_ADDR REGISTER------------------------");
    repeat(32) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.io_addr.reset();
        rst_compare(dma_model.io_addr,status);
        rst = 0;
      end
      dma_model.io_addr.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: io_addr(RW|32) = %0h",pread);
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
      dma_model.io_addr.write(status,written,UVM_FRONTDOOR);
      dma_model.io_addr.peek(status,read);
      $display("AFTER WRITING %0h: io_addr(RW|32) = %0h",written,pread);

      //CHECK FOR RW FIELD
      if(read == written)
        `uvm_info("IO_ADDR","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("IO_ADDR","IS NOT READ WRITE REGISTER")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: io_addr(RW|32) = %0h",pread);

    $display("POKING 32'hFFFFFFFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.io_addr.poke(status,32'hFFFFFFFF);
    dma_model.io_addr.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: io_addr(RW|32) = %0h",32'hFFFFFFFF,read);
    if(read != 32'hFFFFFFFF)
      `uvm_error("IO_ADDR REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
