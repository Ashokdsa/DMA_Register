class descriptor_addr_reg extends uvm_reg;
  `uvm_object_utils(descriptor_addr_reg)
  rand uvm_reg_field descriptor_addr;

  covergroup descriptor_addr_cg;
    option.per_instance = 1;
    descriptor_addr_cp: coverpoint descriptor_addr.value
    {
      bins descriptor_addr_bin[] = {[0:32'h80000000]} with ($onehot0(item));
    }
  endgroup

  function new(string name = "descriptor_addr_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      descriptor_addr_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    descriptor_addr_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    descriptor_addr_cg.sample();
  endfunction

  function void build();
    descriptor_addr = uvm_reg_field::type_id::create("descriptor_addr");
    descriptor_addr.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset('h00000000),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
  endfunction
endclass
