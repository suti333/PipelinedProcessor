module PCReg
(
    input clk, reset, pcwriteEn,
    input [31:0] pc_inp,
    output reg [31:0] pc
);

initial begin
    pc = 32'b0;
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        pc = 32'b0;
    end
    else begin
        if(pcwriteEn) begin
            pc <= pc_inp;
        end
    end
end

endmodule
