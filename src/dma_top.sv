`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dma_interface.sv"
//ADD DESIGN
`include "dma_pkg.svh"
import dma_pkg::*;

module dma_top;
  bit clk;

  always #5 clk = ~clk;      

  dma_inf vif(clk);     

  // DUT instantiation
  
  initial begin
    uvm_config_db#(virtual dma_inf)::set(null, "*", "vif", vif);
    $dumpfile("wave.vcd");
    $dumpvars(0);
  end

  initial begin:test_run
    run_test("dma_base_test");      // Start UVM test
    $finish;
  end:test_run

endmodule:top
