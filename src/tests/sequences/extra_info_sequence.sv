class extra_info_sequence extends dma_base_sequence;
  `uvm_object_utils(extra_info_sequence)    //Factory Registration

  function new(string name = "extra_info_sequence");
    super.new(name);
  endfunction:new

  task body();
    int i;
    uvm_status_e status;
    $display("------------------------TESTING EXTRA_INFO REGISTER------------------------");
    repeat(32) begin
      //RESET IF SEQUENCE IS CALLED ALONE
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      if(rst)
      begin
        dma_model.extra_info.reset();
        rst_compare(dma_model.extra_info,status);
        rst = 0;
      end
      dma_model.extra_info.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: extra_info(RW|32) = %0h",pread);
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
      dma_model.extra_info.write(status,written,UVM_FRONTDOOR);
      dma_model.extra_info.peek(status,read);
      $display("AFTER WRITING %0h: extra_info(RW|32) = %0h",written,read);

      //CHECK FOR RW FIELD
      if(read == written)
        `uvm_info("EXTRA_INFO","IS A READ WRITE REGISTER",UVM_LOW)
      else
        `uvm_error("EXTRA_INFO","IS NOT READ WRITE REGISTER")
    end
    $display("--------------------------------------------------------------------------\nINITIAL VALUE: extra_info(RW|32) = %0h",pread);

    $display("POKING 32'hFFFFFFFF INTO THE REGISTER");
    //CHECK IF READ WORKS PROPERLY
    dma_model.extra_info.poke(status,32'hFFFFFFFF);
    dma_model.extra_info.read(status,read,UVM_FRONTDOOR);
    $display("AFTER WRITING %0h: extra_info(RW|32) = %0h",32'hFFFFFFFF,read);
    if(read != 32'hFFFFFFFF)
      `uvm_error("EXTRA_INFO REGISTER","READ OPERATION DOES NOT WORK HERE")
  endtask
endclass
