//APB MASTER sequence item 

class dma_sequence_item extends uvm_sequence_item;
   rand logic wr_en;
   rand logic rd_en;
   rand logic [31:0] wdata;
   rand logic [31:0] addr;
   rand logic rst_n;
   logic [31:0] rdata;

  // Factory registration
  `uvm_object_utils_begin(dma_sequence_item)
    `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_field_int(rd_en, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
  `uvm_object_utils_end


  function new(string name = "dma_sequence_item");
     super.new(name);
  endfunction:new
  
endclass:dma_sequence_item
