class mem_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(mem_addr_sequence)    //Factory Registration

  function new(string name = "mem_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING MEM_ADDR REGISTER------------------------");
    if(rst)
    begin
      dma_model.mem_addr.reset();
      rst_compare(dma_model.mem_addr,status);
      rst = 0;
    end
    repeat(32) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      dma_model.mem_addr.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: mem_addr(RW|32) = %0h",pread);
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
          dma_model.mem_addr.randomize();
          written = dma_model.mem_addr.mem_addr.value; 
        end
      end
      if(idx != 0) val.delete(idx-1);
      else if(val.size() > 0) val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.mem_addr.write(status,written,UVM_FRONTDOOR);
      dma_model.mem_addr.peek(status,read);
      $display("AFTER WRITING %0h: mem_addr(RW|32) = %0h",written,read);

      //CHECK FOR RW FIELD
      if(read == written)
        `uvm_info("MEM_ADDR","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("MEM_ADDR","IS NOT READ WRITE REGISTER")

      $display("--------------------------------------------------------------------------\nINITIAL VALUE: mem_addr(RW|32) = %0h",pread);

      $display("POKING 32'h%0d INTO THE REGISTER",written);
      //CHECK IF READ WORKS PROPERLY
      dma_model.mem_addr.poke(status,written);
      dma_model.mem_addr.read(status,read,UVM_FRONTDOOR);
      $display("AFTER WRITING %0h: mem_addr(RW|32) = %0h",written,read);
      if(read != written)
        `uvm_error("MEM_ADDR REGISTER","READ OPERATION DOES NOT WORK HERE")
    end
  endtask
endclass
