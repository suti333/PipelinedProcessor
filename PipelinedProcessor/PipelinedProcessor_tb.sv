`timescale 1ns / 1ns
`include "PipelinedProcessor.sv"

module PipelinedProcessor_tb;

reg clk, reset;
PipelinedProcessor uut(clk, reset);

always begin
    clk = 1'b0;
    #10 clk = ~clk;
    #10;
end

initial begin
    $dumpfile("PipelinedProcessor_tb.vcd");
    $dumpvars(0, PipelinedProcessor_tb);
end

initial begin
    reset = 1'b1;
    #110;
    reset = 1'b0;
    #500;
    $finish;
end

endmodule