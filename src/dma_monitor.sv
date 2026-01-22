class dma_monitor extends uvm_monitor;
  virtual dma_inf vif;
  uvm_analysis_port #(dma_sequence_item) item_collected_port;
  dma_sequence_item seq_item;

  `uvm_component_utils(dma_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dma_inf)::get(this, "", "vif", vif))
       `uvm_fatal(get_name,{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction:build_phase

  virtual task run_phase(uvm_phase phase);
    @(vif.mon_cb);
    forever begin
      repeat(3)@(vif.mon_cb);
      seq_item = dma_sequence_item::type_id::create("seq_item");
      seq_item.wr_en = vif.mon_cb.wr_en;
      seq_item.rd_en = vif.mon_cb.rd_en;
      seq_item.wdata = vif.mon_cb.wdata;
      seq_item.addr  = vif.mon_cb.addr; 
      seq_item.rst_n = vif.mon_cb.rst_n;
      seq_item.rdata = vif.mon_cb.rdata;
      item_collected_port.write(seq_item);
      `uvm_info(get_name,$sformatf("MON RECIEVED\nRSTN = %1b write_en = %1b read_en = %1b addr = %4h wdata = %8h rdata = %8h",
        seq_item.rst_n,
        seq_item.wr_en,
        seq_item.rd_en,
        seq_item.addr,
        seq_item.wdata,
        seq_item.rdata
        ),
        UVM_MEDIUM)
    end
  endtask:run_phase
endclass:dma_monitor
