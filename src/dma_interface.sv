interface dma_inf(input logic clk);
  logic wr_en;
  logic rd_en;
  logic [31:0] wdata;
  logic [31:0] addr;
  logic rst_n;
  logic [31:0] rdata;

  clocking drv_cb @(posedge clk);	// Driver clocking block
    default input #1 output #0;
    output wr_en;
    output rd_en;
    output wdata;
    output addr;
    output rst_n;
  endclocking

  clocking mon_cb@(posedge clk);	// Passive monitor clocking block
    default input #1 output #0;
    input wr_en;
    input rd_en;
    input wdata;
    input addr;
    input rst_n;
    input rdata;
  endclocking

endinterface:dma_inf
