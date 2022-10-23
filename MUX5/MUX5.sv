module MUX5
(
    input select,
    input [4:0] i0, i1,
    output reg [4:0] out
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