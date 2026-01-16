`include "dma_reg_pkg.svh"
import dma_reg_pkg::*;

class intr_reg extends uvm_reg;
  `uvm_object_utils(intr_reg)
  rand uvm_reg_field intr_mask;
  uvm_reg_field intr_status;

  covergroup intr_cg;
    option.per_instance = 1;
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

class ctrl_reg extends uvm_reg;
  `uvm_object_utils(ctrl_reg)
  rand uvm_reg_field start_dma, w_count, io_mem;
  uvm_reg_field Reserved;

  covergroup ctrl_cg;
    option.per_instance = 1;
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
  endfunction
endclass

class io_addr_reg extends uvm_reg;
  `uvm_object_utils(io_addr_reg)
  rand uvm_reg_field io_addr;

  covergroup io_addr_cg;
    option.per_instance = 1;
  endgroup

  function new(string name = "io_addr_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      io_addr_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    io_addr_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    io_addr_cg.sample();
  endfunction

  function void build();
    io_addr = uvm_reg_field::type_id::create("io_addr");
    io_addr.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset('h00000000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction
endclass

class mem_addr_reg extends uvm_reg;
  `uvm_object_utils(mem_addr_reg)
  rand uvm_reg_field mem_addr;

  covergroup mem_addr_cg;
    option.per_instance = 1;
  endgroup

  function new(string name = "mem_addr_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      mem_addr_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    mem_addr_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    mem_addr_cg.sample();
  endfunction

  function void build();
    mem_addr = uvm_reg_field::type_id::create("mem_addr");
    mem_addr.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset('h00000000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction
endclass

class extra_info_reg extends uvm_reg;
  `uvm_object_utils(extra_info_reg)
  rand uvm_reg_field extra_info;

  covergroup extra_info_cg;
    option.per_instance = 1;
  endgroup

  function new(string name = "extra_info_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      extra_info_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    extra_info_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    extra_info_cg.sample();
  endfunction

  function void build();
    extra_info = uvm_reg_field::type_id::create("extra_info");
    extra_info.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset('h00000000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction
endclass

class status_reg extends uvm_reg;
  `uvm_object_utils(status_reg)
  uvm_reg_field busy,done,error,paused,current_state,fifo_level,Reserved;

  covergroup status_cg;
    option.per_instance = 1;
  endgroup

  function new(string name = "status_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      status_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    status_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    status_cg.sample();
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
      .is_rand(0),
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
      .is_rand(0),
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
      .is_rand(0),
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
      .is_rand(0),
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
      .is_rand(0),
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
      .is_rand(0),
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
  endfunction
endclass


class transfer_count_reg extends uvm_reg;
  `uvm_object_utils(transfer_count_reg)
  uvm_reg_field transfer_count;

  covergroup transfer_count_cg;
    option.per_instance = 1;
  endgroup

  function new(string name = "transfer_count_reg");
    super.new(name,32,UVM_CVR_FIELD_VALS);
    if(has_coverage(UVM_CVR_FIELD_VALS))
      transfer_count_cg = new();
  endfunction

  function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
    transfer_count_cg.sample();
  endfunction

  function void sample_values();
    super.sample_values();
    transfer_count_cg.sample();
  endfunction

  function void build();
    transfer_count = uvm_reg_field::type_id::create("transfer_count");
    transfer_count.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset('h00000000),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction
endclass

class descriptor_addr_reg extends uvm_reg;
  `uvm_object_utils(descriptor_addr_reg)
  rand uvm_reg_field descriptor_addr;

  covergroup descriptor_addr_cg;
    option.per_instance = 1;
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
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction
endclass

class error_status_reg extends uvm_reg;
  `uvm_object_utils(error_status_reg)
  rand uvm_reg_field bus_error,timeout_error,alignment_error,overflow_error,underflow_error;
  uvm_reg_field Reserved,error_code,error_addr_offset;

  covergroup error_status_cg;
    option.per_instance = 1;
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
  endfunction
endclass

class config_reg extends uvm_reg;
  `uvm_object_utils(config_reg)
  rand uvm_reg_field prioriti, auto_restart, interrupt_enable, burst_size, data_width, descriptor_mode; 
  uvm_reg_field Reserved;

  covergroup config_cg;
    option.per_instance = 1;
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
      .lsb_pos(0),
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
  endfunction
endclass

