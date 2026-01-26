class ctrl_reg extends uvm_reg;
  `uvm_object_utils(ctrl_reg)
  rand uvm_reg_field start_dma, w_count, io_mem;
  uvm_reg_field Reserved;

  covergroup ctrl_cg;
    option.per_instance = 1;
    start_cp: coverpoint start_dma.value;
    w_count_cp: coverpoint w_count.value
    {
      bins w_count_bin[16] = {[0:$]};
    }
    io_mem_cp: coverpoint io_mem.value;
  endgroup

  function new(string name = "ctrl_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      ctrl_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    ctrl_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    ctrl_cg.sample();
  endfunction

  function void build();
    start_dma = uvm_reg_field::type_id::create("start_dma");
    start_dma.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    w_count = uvm_reg_field::type_id::create("w_count");
    w_count.configure(
      .parent(this),
      .size(15),
      .lsb_pos(1),
      .access("RW"),
      .volatile(0),
      .reset('h00),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    io_mem = uvm_reg_field::type_id::create("io_mem");
    io_mem.configure(
      .parent(this),
      .size(1),
      .lsb_pos(16),
      .access("RW"),
      .volatile(0),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    Reserved = uvm_reg_field::type_id::create("Reserved");
    Reserved.configure(
      .parent(this),
      .size(15),
      .lsb_pos(17),
      .access("RO"),
      .volatile(0),
      .reset('h0000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    Reserved.set_compare(UVM_NO_CHECK);
  endfunction
endclass
