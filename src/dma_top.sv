`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dma_interface.sv"
`include "design/dma_design.sv"
`include "dma_pkg.svh"
import dma_pkg::*;

module dma_top;
  bit clk;

  always #5 clk = ~clk;      

  dma_inf vif(clk);     

  dma_design dut(
    vif.clk,
    vif.rst_n,
    vif.wr_en,
    vif.rd_en,
    vif.wdata,
    vif.addr,
    vif.rdata
  );
  
  initial begin
    uvm_config_db#(virtual dma_inf)::set(null, "*", "vif", vif);
    $dumpfile("wave.vcd");
    $dumpvars(0);
  end

  initial begin
    vif.rst_n = 0;
    @(posedge clk);
    vif.rst_n = 1;
  end

  initial begin:test_run
    run_test("dma_base_test");      // Start UVM test
    $finish;
  end:test_run

endmodule:dma_top
