class dma_subscriber extends uvm_subscriber#(dma_sequence_item);
  `uvm_component_utils(dma_subscriber)    // Factory registration
  dma_sequence_item seq;
  
  covergroup cg();
    reset_cp: coverpoint seq.rst_n;
    wr_en_cp: coverpoint seq.wr_en;
    rd_en_cp: coverpoint seq.rd_en;
    addr_cp: coverpoint seq.addr
    {
      bins to_cover[] = {'h400,'h404,'h408,'h40C,'h412,'h416,'h420,'h424};
    }
    wdata_cp: coverpoint seq.wdata;
    rdata_cp: coverpoint seq.rdata;

    wrxaddr: cross wr_en_cp,addr_cp
    {
      bins normal = binsof(wr_en_cp) intersect {1'b1};
      ignore_bins others = binsof(wr_en_cp) intersect {1'b0};
    }
    rdxaddr: cross rd_en_cp,addr_cp
    {
      bins normal = binsof(rd_en_cp) intersect {1'b1};
      ignore_bins others = binsof(rd_en_cp) intersect {1'b0};
    }

  endgroup
  
  function new(string name = "subs", uvm_component parent = null);
    super.new(name,parent);
    cg = new();
  endfunction:new

  virtual function void write(dma_sequence_item t);
    seq = t;
    cg.sample();
    `uvm_info(get_name,"[MONITOR]:INPUT RECIEVED",UVM_DEBUG)
  endfunction:write

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name,$sformatf("COVERAGE = %0f\n",cg.get_coverage()),UVM_NONE);
  endfunction:report_phase

endclass:dma_subscriber
