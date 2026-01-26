class dma_base_sequence extends uvm_sequence#(dma_sequence_item); //BASE sequence
  `uvm_object_utils(dma_base_sequence)    //Factory Registration
  dma_sequence_item seq;
  dma_reg_block dma_model;
  bit rst = 1'b1;
  bit[31:0] written,read,pread;
  bit[31:0] val[$];
  bit[4:0] idx;

  function new(string name = "dma_base_sequence");
    bit[31:0] i = 1'b1;
    super.new(name);
    repeat(32) 
    begin
      val.push_back(i);
      i = i << 1;
    end
    $write("VAL = ");
    foreach(val[i])
      $write("%0h ",val[i]);
    $display();
  endfunction:new

  task body();
    `uvm_fatal(get_name,"NOT EXTENDED")
  endtask

  task rst_compare(uvm_reg a,uvm_status_e status);
    bit[31:0] read;
    a.read(status,read,UVM_BACKDOOR);
    if(read == 32'h00000000)
      `uvm_info(a.get_name,"RESET WORKS HERE",UVM_NONE)
    else
      `uvm_warning(a.get_name,"RESET VALUE DIFFERS")
  endtask

  task proper_val(int pos,int sz,ref bit[31:0] read,ref bit[31:0] pread);
    for(int i = 0; i < 32; i++) //ENSURES ONLY THE DATA OF THE FIELD IS SHOWN
    begin:valid_read
      if(i < pos && i >= pos+sz)
      begin
        pread[i] = 1'b0;
        read[i] = 1'b0;
      end
    end:valid_read
  endtask
endclass
