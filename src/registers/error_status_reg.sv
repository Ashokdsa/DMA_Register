class error_status_reg extends uvm_reg;
  `uvm_object_utils(error_status_reg)
  rand uvm_reg_field bus_error,timeout_error,alignment_error,overflow_error,underflow_error;
  uvm_reg_field Reserved,error_code,error_addr_offset;

  covergroup error_status_cg;
    option.per_instance = 1;
    bus_error_cp: coverpoint bus_error.value;
    timeout_error_cp: coverpoint timeout_error.value;
    alignment_error_cp: coverpoint alignment_error.value;
    overflow_error_cp: coverpoint overflow_error.value;
    underflow_error_cp: coverpoint underflow_error.value;
  endgroup

  function new(string name = "error_status_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      error_status_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    error_status_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    error_status_cg.sample();
  endfunction

  function void build();
    bus_error = uvm_reg_field::type_id::create("bus_error");
    bus_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(1),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    timeout_error = uvm_reg_field::type_id::create("timeout_error");
    timeout_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("W1C"),
      .volatile(1),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    alignment_error = uvm_reg_field::type_id::create("alignment_error");
    alignment_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("W1C"),
      .volatile(1),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    overflow_error = uvm_reg_field::type_id::create("overflow_error");
    overflow_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(3),
      .access("W1C"),
      .volatile(1),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    underflow_error = uvm_reg_field::type_id::create("underflow_error");
    underflow_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(4),
      .access("W1C"),
      .volatile(1),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    Reserved = uvm_reg_field::type_id::create("Reserved");
    Reserved.configure(
      .parent(this),
      .size(3),
      .lsb_pos(5),
      .access("RO"),
      .volatile(1),
      .reset('h0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    error_code = uvm_reg_field::type_id::create("error_code");
    error_code.configure(
      .parent(this),
      .size(8),
      .lsb_pos(8),
      .access("RO"),
      .volatile(1),
      .reset('h00),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    error_addr_offset = uvm_reg_field::type_id::create("error_addr_offset");
    error_addr_offset.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RO"),
      .volatile(1),
      .reset('h0000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    Reserved.set_compare(UVM_NO_CHECK);
    error_code.set_compare(UVM_NO_CHECK);
    error_addr_offset.set_compare(UVM_NO_CHECK);
  endfunction
endclass
