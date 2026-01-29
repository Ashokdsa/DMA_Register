class extra_info_sequence extends dma_base_sequence;
  `uvm_object_utils(extra_info_sequence)    //Factory Registration

  function new(string name = "extra_info_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING EXTRA_INFO REGISTER------------------------");
    //RESET IF SEQUENCE IS CALLED ALONE
    if(rst)
    begin
      dma_model.extra_info.reset();
      rst_compare(dma_model.extra_info,status);
      rst = 0;
    end
    repeat(50) begin
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      dma_model.extra_info.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: extra_info(RW|32) = %0h",pread);
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
          dma_model.extra_info.randomize();
          written = dma_model.extra_info.extra_info.value; 
        end
      end
      if(idx != 0) val.delete(idx-1);
      else if(val.size() > 0) val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.extra_info.write(status,written,UVM_FRONTDOOR);
      dma_model.extra_info.peek(status,read);
      $display("AFTER WRITING %0h: extra_info(RW|32) = %0h",written,read);

      //CHECK FOR RW FIELD
      if(read == written)
        `uvm_info("EXTRA_INFO","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("EXTRA_INFO","IS NOT READ WRITE REGISTER")

      $display("--------------------------------------------------------------------------\nINITIAL VALUE: extra_info(RW|32) = %0h",read);

      $display("POKING 32'h%0h INTO THE REGISTER",written);
      //CHECK IF READ WORKS PROPERLY
      dma_model.extra_info.poke(status,written);
      dma_model.extra_info.read(status,read,UVM_FRONTDOOR);
      $display("AFTER WRITING %0h: extra_info(RW|32) = %0h",written,read);
      if(read != written)
        `uvm_error("EXTRA_INFO REGISTER","READ OPERATION DOES NOT WORK HERE")
    end
  endtask
endclass
