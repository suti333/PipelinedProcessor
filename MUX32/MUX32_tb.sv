`timescale 1ns / 1ns
`include "MUX32.sv"

module MUX32_tb;

reg select;
reg [31:0] i0, i1;
wire [31:0] out;

MUX32 uut(select, i0, i1, out);

initial begin
    $dumpfile("MUX32_tb.vcd");
    $dumpvars(0, MUX32_tb);
    i0 = 32'd21;
    i1 = 32'd15;
    select = 1'b0;
    #20;

    select = 1'b1;
    #20;
end
endmodule