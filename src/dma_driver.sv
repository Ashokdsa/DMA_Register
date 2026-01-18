class dma_driver extends uvm_driver #(dma_sequence_item);
  virtual dma_inf vif;
  `uvm_component_utils(dma_driver)
    
  function new (string name = "dma_driver", uvm_component parent);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dma_inf)::get(this, "", "vif", vif))
      `uvm_fatal(get_name,{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req); 
        drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    @(vif.drv_cb);
    if(req.rst_n == 1'b0)
    begin
      vif.drv_cb.rst_n <= 1'b0;
      vif.drv_cb.wr_en <= 1'b0;
      vif.drv_cb.rd_en <= 1'b0;
      vif.drv_cb.wdata <= 'h00000000;
      vif.drv_cb.addr  <= 'h00000000;
    end
    else begin
      vif.drv_cb.rst_n <= 1'b1;
      vif.drv_cb.wr_en <= req.wr_en;
      vif.drv_cb.rd_en <= req.rd_en;
      vif.drv_cb.wdata <= req.wdata;
      vif.drv_cb.addr  <= req.addr;
    end
    `uvm_info(get_name,$sformatf("--------------------------------%0d inputs sent--------------------------------\n",count),UVM_DEBUG);
    `uvm_info(get_name,$sformatf("RST_N:%0b WR:%0b RD:%0b WDATA = %0d ADDR = %0d",
      req.rst_n, 
      req.wr_en,
      req.rd_en,
      req.wdata,
      req.addr 
      ),
      UVM_DEBUG)
    @(vif.drv_cb);
  endtask
endclass
