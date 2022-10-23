module MEMWBReg
( 
    input clk, reset, MEMMemtoReg, MEMRegWrite,
    input [31:0] MEMreadData, MEMALURes,
    input  [4:0] MEMwriteReg,
    output reg WBMemtoReg, WBRegWrite,
    output reg [31:0] WBreadData, WBALURes,
    output reg [4:0] WBwriteReg
);

always @(reset) begin
    if(reset == 1'b1) begin
        WBMemtoReg <= 1'b0;
        WBRegWrite <= 1'b0;
        WBreadData <= 32'b0;
        WBALURes <= 32'b0;
        WBwriteReg <= 5'b0;
    end
end

always @(posedge clk) begin
    WBMemtoReg <= MEMMemtoReg;
    WBRegWrite <= MEMRegWrite;
    WBreadData <= MEMreadData;
    WBALURes <= MEMALURes;
    WBwriteReg <= MEMwriteReg;
end
endmodule