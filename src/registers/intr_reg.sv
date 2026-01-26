class intr_reg extends uvm_reg;
  `uvm_object_utils(intr_reg)
  rand uvm_reg_field intr_mask;
  uvm_reg_field intr_status;

  covergroup intr_cg;
    option.per_instance = 1;
    mask_cp: coverpoint intr_mask.value
    {
      bins intr_mas[17] = {[0:$]};
    }
  endgroup

  function new(string name = "intr_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      intr_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    intr_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    intr_cg.sample();
  endfunction

  function void build();
    intr_status = uvm_reg_field::type_id::create("intr_status");
    intr_status.configure(
      .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset('h00),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    intr_status.set_compare(UVM_NO_CHECK);
    intr_mask = uvm_reg_field::type_id::create("intr_mask");
    intr_mask.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RW"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
  endfunction
endclass
