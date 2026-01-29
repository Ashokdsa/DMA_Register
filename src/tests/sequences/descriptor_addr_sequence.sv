class descriptor_addr_sequence extends dma_base_sequence;
  `uvm_object_utils(descriptor_addr_sequence)    //Factory Registration

  function new(string name = "descriptor_addr_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING DESCRIPTOR_ADDR REGISTER------------------------");
    //RESET IF SEQUENCE IS CALLED ALONE
    if(rst)
    begin
      dma_model.descriptor_addr.reset();
      rst_compare(dma_model.descriptor_addr,status);
      rst = 0;
    end
    repeat(50) begin
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      dma_model.descriptor_addr.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: descriptor_addr(RW|32) = %0h",pread);
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
          //RANDOM INPUTS
          dma_model.descriptor_addr.randomize();
          written = dma_model.descriptor_addr.descriptor_addr.value; 
        end
      end
      if(idx != 0) val.delete(idx-1);
      else if(val.size() > 0) val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.descriptor_addr.write(status,written,UVM_FRONTDOOR);
      dma_model.descriptor_addr.peek(status,read);
      $display("AFTER WRITING %0h: descriptor_addr(RW|32) = %0h",written,read);

      //CHECK FOR RW FIELD
      if(read == written)
        `uvm_info("DESCRIPTOR_ADDR","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("DESCRIPTOR_ADDR","IS NOT READ WRITE REGISTER")

      $display("--------------------------------------------------------------------------\nINITIAL VALUE: descriptor_addr(RW|32) = %0h",read);

      //CHECK IF READ WORKS PROPERLY
      $display("POKING 32'h%0h INTO THE REGISTER",written);
      dma_model.descriptor_addr.poke(status,written);
      dma_model.descriptor_addr.read(status,read,UVM_FRONTDOOR);
      $display("AFTER READING %0h: descriptor_addr(RW|32) = %0h",written,read);
      if(read != written)
        `uvm_error("DESCRIPTOR_ADDR REGISTER","READ OPERATION DOES NOT WORK HERE")
      else
        `uvm_info("DESCRIPTOR_ADDR REGISTER","READ OPERATION WORKS HERE",UVM_LOW)
    end
  endtask
endclass
