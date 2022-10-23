module MUX32
(
    input select,
    input [31:0] i0, i1,
    output reg [31:0] out
);

always @(*) begin
    if(select == 1'b0) begin
        out <= i0;
    end
    else begin
        out <= i1;
    end
end
endmodule