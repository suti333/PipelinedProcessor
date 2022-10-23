`timescale 1ns / 1ns
`include "RegFile.sv"

module RegFile_tb;

reg clk, reset, regWrite;
reg [4:0] readReg1, readReg2, writeReg;
reg [31:0] writeData;
wire [31:0] readData1, readData2;

RegFile uut(clk, reset, regWrite, readReg1, readReg2, writeReg, writeData, readData1, readData2);

always begin
    clk = 1'b0;
    #10 clk = ~clk;
    #10;
end

initial begin
    $dumpfile("RegFile_tb.vcd");
    $dumpvars(0, RegFile_tb);
    reset = 1'b1;
    #20;

    reset = 1'b0;
    regWrite = 1'b1;
    readReg1 = 5'd0;
    readReg2 = 5'd0;
    writeReg = 5'd4;
    writeData = 32'd12;
    #20;

    writeReg = 5'd5;
    writeData = 32'd6;
    #20;

    regWrite = 1'b0;
    readReg1 = 5'd4;
    readReg2 = 5'd5;
    #20;

    regWrite = 1'b1;
    writeReg = 5'd4;
    writeData = 32'd15;
    #20;
end

initial begin
  #100;
  $finish;
end

endmodule