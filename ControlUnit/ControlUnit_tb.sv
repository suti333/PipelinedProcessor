`timescale 1ns / 1ns
`include "ControlUnit.sv"

module ControlUnit_tb;

reg [5:0] opcode;
wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BEQFlag;
wire [1:0] ALUOp;

ControlUnit uut(opcode,RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BEQFlag,ALUOp);

initial begin
    $dumpfile("ControlUnit_tb.vcd");
    $dumpvars(0, ControlUnit_tb);

    opcode=6'b000000;
    #20;
    opcode=6'b100011;
    #20;
    opcode=6'b101011;
    #20;
    opcode=6'b000010;
    #20;
    opcode=6'b000100;
    #20;
    opcode=6'b000101;
    #20;
end
endmodule