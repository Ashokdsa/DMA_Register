class intr_sequence extends dma_base_sequence;
  `uvm_object_utils(intr_sequence)    //Factory Registration

  function new(string name = "intr_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING INTERRUPT REGISTER------------------------");
    //RESET IF SEQUENCE IS CALLED ALONE
    if(rst)
    begin
      dma_model.intr.reset();
      rst_compare(dma_model.intr,status);
      rst = 0;
    end
    repeat(50) begin
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();

      dma_model.intr.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",pread,pread[15:0],pread[31:16]);
      
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
          dma_model.intr.randomize();
          written = (dma_model.intr.intr_mask.value << 16); 
          written[15:0] = $urandom();
          if(written != pread)
            `uvm_info("INTR VAL",$sformatf("\033[1;31mSTATUS = %0h MASK = %0h\033[0m",written[15:0],dma_model.intr.intr_mask.value),UVM_NONE)
        end
      end
      if(idx != 0) val.delete(idx-1);
      else if(val.size() > 0) val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.intr.write(status,written,UVM_FRONTDOOR);

      dma_model.intr.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",written,read,read[15:0],read[31:16]);

      //CHECK FOR RO FIELD
      if(read[15:0] == pread[15:0])
        `uvm_info("INTR.STATUS","IS A READ ONLY REGISTER FIELD",UVM_LOW)
      else
        `uvm_error("INTR.STATUS","IS NOT READ ONLY REGISTER FIELD")

      //CHECK FOR RW FIELD
      if(read[31:16] == written[31:16])
        `uvm_info("INTR.MASK","IS A READ WRITE REGISTER FIELD",UVM_LOW)
      else
        `uvm_error("INTR.MASK","IS NOT READ WRITE REGISTER FIELD")

      //CHECK IF READ WORKS PROPERLY
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",read,read[15:0],read[31:16]);

      $display("POKING 32'h%0h INTO THE REGISTER",written);
      dma_model.intr.poke(status,written);
      dma_model.intr.read(status,read,UVM_FRONTDOOR);
      $display("AFTER WRITING %0h: FULL = %0h | intr_status(RO|16) = %0h intr_mask(RW|16) = %0h",written,read,read[15:0],read[31:16]);
      if(read != written)
        `uvm_error("INTR REGISTER","READ OPERATION DOES NOT WORK HERE")
    end
  endtask
endclass
