`timescale 1ns / 1ns
`include "SignExtend.sv"

module SignExtend_tb;

reg [15:0] inp;
wire [31:0] out;

SignExtend uut(inp, out);

initial begin
    $dumpfile("SignExtend_tb.vcd");
    $dumpvars(0, SignExtend_tb);
    inp = 16'd25;
    #20;

end

endmodule