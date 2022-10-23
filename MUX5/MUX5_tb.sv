`timescale 1ns / 1ns
`include "MUX5.sv"

module MUX5_tb;

reg select;
reg [4:0] i0, i1;
wire [4:0] out;

MUX5 uut(select, i0, i1, out);

initial begin
    $dumpfile("MUX5_tb.vcd");
    $dumpvars(0, MUX5_tb);
    i0 = 5'd9;
    i1 = 5'd15;
    select = 1'b0;
    #20;

    select = 1'b1;
    #20;
end
endmodule