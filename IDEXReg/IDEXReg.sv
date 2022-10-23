module IDEXReg
(
    input clk, reset, RegDst, ALUSrc, MemRead, MemWrite, Branch, MemtoReg, RegWrite,
    input [31:0] IDpcNext, readData1, readData2, signextendout,
    input [4:0] rt, rd,
    input [1:0] ALUOp,
    output reg EXRegDst, EXALUSrc, EXMemRead, EXMemWrite, EXBranch, EXMemtoReg, EXRegWrite,
    output reg [31:0] EXpcNext, EXreadData1, EXreadData2, EXsignextendout,
    output reg [4:0] EXrt, Exrd,
    output reg [1:0] EXALUOp
);

always @(reset) begin
    if(reset == 1'b1) begin
        EXRegDst <= 1'b0;
        EXALUSrc <= 1'b0;
        EXMemRead <= 1'b0;
        EXMemWrite <= 1'b0;
        EXBranch <= 1'b0;
        EXMemtoReg <= 1'b0;
        EXRegWrite <= 1'b0;
        EXpcNext <= 32'b0;
        EXreadData1 <= 32'b0;
        EXreadData2 <= 32'b0;
        EXsignextendout <= 32'b0;
        EXrt <= 5'b0;
        Exrd <= 5'b0;
        EXALUOp <= 2'b0;
    end
end

always @(posedge clk) begin
	EXRegDst <= RegDst;
    EXALUSrc <= ALUSrc;
    EXMemRead <= MemRead;
    EXMemWrite <= MemWrite;
    EXBranch <= Branch;
    EXMemtoReg <= MemtoReg;
    EXRegWrite <= RegWrite;
    EXpcNext <= IDpcNext;
    EXreadData1 <= readData1;
    EXreadData2 <= readData2;
    EXsignextendout <= signextendout;
    EXrt <= rt;
    Exrd <= rd;
    EXALUOp <= ALUOp;
end

endmodule