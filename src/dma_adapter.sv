class adapter extends uvm_reg_adapter;
  `uvm_oject_utils(adapter)

  function new(string name = "adapter");
    super.new(name);
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    dma_sequence_item tr;
    tr = dma_sequence_item::type_id::create("tr");

    tr.wr_en = (rw.kind == UVM_WRITE);
    tr.rd_en = (rw.kind == UVM_READ);

    tr.wdata = rw.data;
    tr.addr = rw.addr;
    return tr;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    dma_sequence_item tr;
    assert($cast(tr,bus_item);

    if(wr_en == 1)
      rw.kind = UVM_WRITE;
    else if(rd_en == 1)
      rw.kind == UVM_READ;
    //CHECK
    rw.data = tr.rdata;
    rw.addr = tr.addr; 

    rw.status = UVM_IS_OK;
    return tr;
  endfunction

endclass
