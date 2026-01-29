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
    //RESET IF SEQUENCE IS CALLED ALONE
    if(rst)
    begin
      dma_model.status.reset();
      rst_compare(dma_model.status,status);
      rst = 0;
    end
    //FOR PREDICTABLE VALUES
    `uvm_info("STATUS SEQ","BACKDOOR WRITING 0 TO CTRL REG AND THEN POKING 0 TO STATUS AND TRANSFER_COUNT",UVM_HIGH)
    dma_model.ctrl.write(status,32'h00000000,UVM_BACKDOOR);
    dma_model.status.poke(status,32'h00000000);
    dma_model.transfer_count.poke(status,32'h00000000);
    repeat(16) begin
      $write("VAL = ");
      foreach(val[i])
        $write("%0h ",val[i]);
      $display();
      dma_model.status.peek(status,pread);
      $display("--------------------------------------------------------------------------\nINITIAL VALUE: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",pread[15:0],pread[0],pread[1],pread[2],pread[3],pread[7:4],pread[15:8]);

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
          //RANDOM
          dma_model.status.randomize();
          written = (dma_model.status.busy.value) | (dma_model.status.done.value << 1) | (dma_model.status.error.value << 2) | (dma_model.status.paused.value << 3) | (dma_model.status.current_state.value << 4) | (dma_model.status.fifo_level.value << 8); 
        end
      end
      if(idx != 0) val.delete(idx-1);
      else if(val.size() > 0) val.delete(idx);
      
      $display("WRITING VALUE = %0h",written);
      dma_model.status.write(status,written,UVM_FRONTDOOR);
      dma_model.status.peek(status,read);
      $display("AFTER WRITING %0h: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",written,read[15:0],read[0],read[1],read[2],read[3],read[7:4],read[15:8]);

      //CHECK FOR RO FIELD
      if(read[15:0] == pread[15:0])
        `uvm_info("STATUS REGISTER","IS A READ ONLY REGISTER",UVM_LOW)
      else
        `uvm_error("STATUS REGISTER","IS NOT READ ONLY REGISTER")

      $display("-----------------------------------%0t---------------------------------------\nINITIAL VALUE: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",written,pread[15:0],pread[0],pread[1],pread[2],pread[3],pread[7:4],pread[15:8]);

      //UPDATE MIRROR
      dma_model.transfer_count.peek(status,pread);
      dma_model.dma_model.ctrl.w_count.peek(status,pread);

      $display("POKING 32'h%0h INTO THE REGISTER",written);
      //CHECK IF READ WORKS PROPERLY
      dma_model.status.poke(status,written);
      pread[15:8] = written[0] ? dma_model.transfer_count.transfer_count.value[7:0] : written[15:8];
      pread[7:4] = (written[0] && (dma_model.transfer_count.transfer_count.value >= dma_model.ctrl.w_count.value)) ? 4'b0000 : written[7:4];
      pread[1] = (written[0] && (dma_model.transfer_count.transfer_count.value >= dma_model.ctrl.w_count.value)) ? 1'b1 : written[1];
      pread[0] = (written[0] && (dma_model.transfer_count.transfer_count.value >= dma_model.ctrl.w_count.value)) ? 1'b0 : written[0];
      pread[3:2] = written[3:2];
      dma_model.status.read(status,read,UVM_FRONTDOOR);
      $display("AFTER READING %0h: FULL = %0h | busy(RO|1) = %0h done(RO|1) = %0h error(RO|1) = %0h paused(RO|1) = %0h current_state(RO|4) = %0h fifo_level(RO|8) = %0h",written,read[15:0],read[0],read[1],read[2],read[3],read[7:4],read[15:8]);
      $display("\033[1;31m**********************************************************************\nCONSIDERING WE POKED busy = 0 at ctrl_start_dma = %1b checking transfer_count = %8h\nTherefore we compare with\033[0m \033[1;33m 16'b%16b\033[0m\033[1;31m\n**********************************************************************\033[0m",dma_model.ctrl.start_dma.value,dma_model.transfer_count.transfer_count.value,pread);
      if(read[15:0] != pread[15:0])
        `uvm_error("STATUS REGISTER","READ OPERATION DOES NOT WORK HERE")
      else
        `uvm_info("STATUS REGISTER",$sformatf("READ OPERATION DOES WORK HERE, STATE = %4b",read[7:4]),UVM_NONE)
  endtask
endclass
