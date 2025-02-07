`timescale 1ns / 1ps
`include "pointer_fifo.v"

module pointer_fifo_tb;
  // Parameters (match the module)
  parameter DEPTH = 8;
  parameter WIDTH = 8;

  // Signals
  reg in_clk;
  reg out_clk;
  reg in_ready;
  reg out_ready;
  reg reset;
  reg [WIDTH-1:0] data_in;
  wire [WIDTH-1:0] data_out;
  wire fifo_f;
  wire fifo_e;

  // Instantiate the FIFO
  pointer_fifo #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
  ) fifo (
    .in_clk(in_clk),
    .out_clk(out_clk),
    .in_ready(in_ready),
    .out_ready(out_ready),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out),
    .fifo_f(fifo_f),
    .fifo_e(fifo_e)
  );

  // Clock generation
  initial begin
    in_clk = 0;
    out_clk = 0;
    forever #5 in_clk = ~in_clk; // 10ns period for in_clk
  end

  initial begin
    forever #7 out_clk = ~out_clk; // 14ns period for out_clk
  end


  // Test sequence
  initial begin
    reset = 1;
    in_ready = 0;
    out_ready = 0;
    data_in = 0;

    #10; // Reset for a few clock cycles
    reset = 0;

    // Test case 1: Fill the FIFO
    for (integer i = 0; i < DEPTH; i = i + 1) begin
      in_ready = 1;
      data_in = i;
      #10; // Wait for in_clk
      in_ready = 0;
    end

    // Verify full flag
    if (fifo_f != 1) $display("Error: FIFO full flag not set!");

    // Test case 2: Read from the FIFO
    for (integer i = 0; i < DEPTH; i = i + 1) begin
      out_ready = 1;
      #14; // Wait for out_clk
      out_ready = 0;
      $display("Data out: %d", data_out);
      if (data_out != i) $display("Error: Data mismatch!");
    end

    // Verify empty flag
    if (fifo_e != 1) $display("Error: FIFO empty flag not set!");

    // Test case 3: Write and read interleaved
    in_ready = 1;
    data_in = DEPTH;
    #10;
    in_ready = 0;

    out_ready = 1;
    #14;
    out_ready = 0;
    $display("Data out: %d", data_out);

    //Test case 4: Overfilling the FIFO
    for(integer i = 0; i < DEPTH + 2; i = i + 1) begin
        in_ready = 1;
        data_in = i + DEPTH + 1;
        #10;
        in_ready = 0;
    end

    //Test case 5: Over-reading the FIFO
    for (integer i = 0; i < DEPTH + 2; i = i + 1) begin
      out_ready = 1;
      #14; // Wait for out_clk
      out_ready = 0;
      $display("Data out: %d", data_out);
    end

    $finish;
  end

  initial begin
        $dumpfile("pointer_fifo_tb.vcd");
        $dumpvars(0, pointer_fifo_tb);
    end

endmodule
