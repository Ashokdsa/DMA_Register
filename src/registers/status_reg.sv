class status_reg extends uvm_reg;
  `uvm_object_utils(status_reg)
  rand uvm_reg_field busy,done,error,paused,current_state,fifo_level;
  rand uvm_reg_field Reserved;

  function new(string name = "status_reg");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build();
    busy = uvm_reg_field::type_id::create("busy");
    busy.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RO"),
      .volatile(0),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    done = uvm_reg_field::type_id::create("done");
    done.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("RO"),
      .volatile(0),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    error = uvm_reg_field::type_id::create("error");
    error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("RO"),
      .volatile(0),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    paused = uvm_reg_field::type_id::create("paused");
    paused.configure(
      .parent(this),
      .size(1),
      .lsb_pos(3),
      .access("RO"),
      .volatile(0),
      .reset('b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    current_state = uvm_reg_field::type_id::create("current_state");
    current_state.configure(
      .parent(this),
      .size(4),
      .lsb_pos(4),
      .access("RO"),
      .volatile(0),
      .reset('h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    fifo_level = uvm_reg_field::type_id::create("fifo_level");
    fifo_level.configure(
      .parent(this),
      .size(8),
      .lsb_pos(8),
      .access("RO"),
      .volatile(0),
      .reset('h00),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
    Reserved = uvm_reg_field::type_id::create("Reserved");
    Reserved.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RO"),
      .volatile(0),
      .reset('b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
    busy.set_compare(UVM_NO_CHECK);
    done.set_compare(UVM_NO_CHECK);
    error.set_compare(UVM_NO_CHECK);
    paused.set_compare(UVM_NO_CHECK);
    current_state.set_compare(UVM_NO_CHECK);
    fifo_level.set_compare(UVM_NO_CHECK);
    Reserved.set_compare(UVM_NO_CHECK);
  endfunction
endclass
