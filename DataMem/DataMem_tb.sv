`timescale 1ns / 1ns
`include "DataMem.sv"

module DataMem_tb;

reg clk, memWrite, memRead;
reg [31:0] address, writeData;
wire [31:0] readData;

DataMem uut( clk, memWrite, memRead, address, writeData, readData);

always begin
    clk = 1'b0;
    #10 clk = ~clk;
    #10;
end

initial begin
    $dumpfile("DataMem_tb.vcd");
    $dumpvars(0, DataMem_tb);
    memWrite = 1'b1;
    memRead = 1'b0;
    address = 32'd32;
    writeData = 32'd18;
    #20;
  
    address = 32'd36;
    writeData = 32'd21;
    #20;
  
    memWrite = 1'b0;
    memRead = 1'b1;
    address = 32'd32;
    #20;

    address=32'd36;
    #20;
end

initial begin
    #100;
    $finish;
end

endmodule