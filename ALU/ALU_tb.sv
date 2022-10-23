`timescale 1ns / 1ns
`include "ALU.sv"

module ALU_tb;

reg [31:0] op1, op2;
reg [3:0] ALUControl;
wire [31:0] ALURes;
wire zero;

ALU uut(op1, op2, ALUControl, ALURes, zero);

initial begin
    $dumpfile("ALU_tb.vcd");
    $dumpvars(0, ALU_tb);
    op1 = 32'd8;
    op2 = 32'd7;
    ALUControl = 4'b0010;
    #20 ALUControl = 4'b0110;
    #20 ALUControl = 4'b0000;
    #20 ALUControl = 4'b0001;
    #20;
end
endmodule
