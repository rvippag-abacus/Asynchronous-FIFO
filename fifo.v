///////////////////////////////////////////////////////////////
//
// Company: Abacus Semiconductor Corporation
// Engineer:  <include your name here, list can grow>
//
// Copyright (C) 2020-2025 Abacus Semiconductor Corporation
//
// This file and all derived works are confidential property of 
// Abacus Semiconductor Corporation
// 
// Create Date:   2025-02-07
// Design Name:   Asynchronous FIFO
// Module Name:   fifo.v
// Project Name:  Asynchronous FIFO
// Target Device: (FPGA: AMD/Xilinx Virtex UltraScale+) (ASIC: TSMC 16nm)
// Tool versions: all
// Description:   The FIFO module is designed to handle data buffering with separate input and output clocks,
//                making it suitable for asynchronous data transfer for the HRAM smart multi-homed memory
//
// Dependencies:  None
//
// Revision:   0.01 - Design started
//
// Additional Comments: Example Comments
//
//   This design is universal and can be parallelized
//
//
/////////////////////////////////////////////////////////////



module fifo #(
    parameter DEPTH = 8,  // FIFO depth
    parameter WIDTH = 8   // Data width
)(
    input in_clk,
    input out_clk,
    input in_ready,
    input out_ready,
    input reset,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg fifo_f,
    output reg fifo_e
);

    reg [WIDTH-1:0] fifo [0:DEPTH-1];
    reg [$clog2(DEPTH)-1:0] raddr;  // Read address pointer
    reg [$clog2(DEPTH)-1:0] waddr;  // Write address pointer
    reg [DEPTH:0] count; // Counter to track the number of elements in the FIFO

    always @(posedge in_clk or posedge reset) begin
        if (reset) begin
            fifo_e <= 1'b1;
            fifo_f <= 1'b0;
            raddr <= 0;
            waddr <= 0;
            count <= 0;
        end else if (in_ready && !fifo_f) begin
            count <= count + 1;
            fifo[waddr] <= data_in;
            waddr <= (waddr + 1) % DEPTH;
            if (count == DEPTH -1) begin
                fifo_f <= 1'b1;
            end
            fifo_e <= 1'b0;
        end
    end

    always @(posedge out_clk) begin
        if (reset) begin
           //Do Nothing
        end else if (out_ready && !fifo_e) begin
            data_out <= fifo[raddr];
            raddr <= (raddr + 1) % DEPTH;
            count <= count - 1;
            if (count == 1) begin
                fifo_e <= 1'b1;
            end
            fifo_f <= 1'b0;
        end
    end

endmodule
