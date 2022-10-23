module EXMEMReg
( 
    input clk, reset, EXMemRead, EXMemWrite, EXBranch, EXMemtoReg, EXRegWrite, zero,
    input [31:0] EA, ALURes, EXreadData2,
    input[4:0] writeReg,
    output reg MEMMemRead, MEMMemWrite, MEMBranch, MEMMemtoReg, MEMRegWrite, MEMzero,
    output reg [31:0] MEMEA, MEMreadData2, MEMALURes,
    output reg [4:0] MEMwriteReg
);

always @(reset) begin
    if(reset == 1'b1) begin
        MEMMemRead <= 1'b0;
        MEMMemWrite <= 1'b0;
        MEMBranch <= 1'b0;
        MEMMemtoReg <= 1'b0;
        MEMRegWrite <= 1'b0;
        MEMzero <= 1'b0;
        MEMEA <= 32'b0;
        MEMreadData2 <= 32'b0;
        MEMALURes <= 32'b0;
        MEMwriteReg <= 5'b0;
    end
end

always @(posedge clk) begin  
    MEMMemRead <= EXMemRead;
    MEMMemWrite <= EXMemWrite;
    MEMBranch <= EXBranch;
    MEMMemtoReg <= EXMemtoReg;
    MEMRegWrite <= EXRegWrite;
    MEMzero <= zero;
    MEMEA <= EA;
    MEMreadData2 <= EXreadData2;
    MEMALURes <= ALURes;
    MEMwriteReg <= writeReg;
end
endmodule