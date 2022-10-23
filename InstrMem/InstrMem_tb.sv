`timescale 1ns / 1ns
`include "InstrMem.sv"

module InstrMem_tb;

reg [31:0] pc;
wire [31:0] instr;

InstrMem uut(pc, instr);

initial begin
    $dumpfile("InstrMem_tb.vcd");
    $dumpvars(0, InstrMem_tb);
    pc = 32'd0;
    #20;

    pc = pc + 32'b100;
    #20;

    pc = pc + 32'b100;
    #20;
end
endmodule
