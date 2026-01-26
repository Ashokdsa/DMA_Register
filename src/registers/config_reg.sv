class config_reg extends uvm_reg;
  `uvm_object_utils(config_reg)
  rand uvm_reg_field prioriti, auto_restart, interrupt_enable, burst_size, data_width, descriptor_mode; 
  uvm_reg_field Reserved;

  covergroup config_cg;
    option.per_instance = 1;
    prioriti_cp: coverpoint prioriti.value
    {
      bins val[] = {0,1,2};
    }
    auto_restart_cp: coverpoint auto_restart.value
    {
      bins val[] = {[0:1]};
    }
    interrupt_enable_cp: coverpoint interrupt_enable.value
    {
      bins val[] = {[0:1]};
    }
    burst_size_cp: coverpoint burst_size.value
    {
      bins val[] = {0,1,2};
    }
    data_width_cp: coverpoint data_width.value
    {
      bins val[] = {0,1,2};
    }
    descriptor_mode_cp: coverpoint descriptor_mode.value
    {
      bins val[] = {[0:1]};
    }
  endgroup

  function new(string name = "config_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      config_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    config_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    config_cg.sample();
  endfunction

  function void build();
    prioriti = uvm_reg_field::type_id::create("prioriti");
    prioriti.configure(
      .parent(this),
      .size(2),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    auto_restart = uvm_reg_field::type_id::create("auto_restart");
    auto_restart.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("RW"),
      .volatile(1),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    interrupt_enable = uvm_reg_field::type_id::create("interrupt_enable");
    interrupt_enable.configure(
      .parent(this),
      .size(1),
      .lsb_pos(3),
      .access("RW"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    burst_size = uvm_reg_field::type_id::create("burst_size");
    burst_size.configure(
      .parent(this),
      .size(2),
      .lsb_pos(4),
      .access("RW"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    data_width = uvm_reg_field::type_id::create("data_width");
    data_width.configure(
      .parent(this),
      .size(2),
      .lsb_pos(6),
      .access("RW"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    descriptor_mode = uvm_reg_field::type_id::create("descriptor_mode");
    descriptor_mode.configure(
      .parent(this),
      .size(1),
      .lsb_pos(8),
      .access("RW"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    Reserved = uvm_reg_field::type_id::create("Reserved");
    Reserved.configure(
      .parent(this),
      .size(23),
      .lsb_pos(9),
      .access("RO"),
      .volatile(0),
      .reset('h000000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    Reserved.set_compare(UVM_NO_CHECK);
  endfunction
endclass
